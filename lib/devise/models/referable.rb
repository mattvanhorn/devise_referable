module Devise
  module Models
    # Referable tracks users that arrive at your site via an affiliate link.
    # Currently this is hardcoded as /ref/:referrer_token/path/to/destination
    # TODO: make url configurable
    # 
    # Classes that act as referrers are specified in the config, and must 
    # have a referrer_token column in the database.
    # TODO: make column name configurable
    # 
    # When a visitor arrives at the site via the referral_landing_path, the following things happen:
    #  - The referrer is looked up, by doing finds against the referrer_types in order.
    #  - If found, a referral record is created with a unique referral_token.
    #  - The referral_token is also stored in a cookie
    #  - The visitor is then redirected to the path appended to the referral_landing_path (i.e. /path/to/destination above)
    #  - If no path is given, they're redirected to the root path.
    #  - If the visitor registers before the cookie expires, the referral record is updated with the new user id, and the cookie is cleared.
    # 
    # Configuration:
    # 
    #   referrer_types: an array of symbols for classes that can refer users. i.e. [:blog, :customer, :user]

    module Referable
      extend ActiveSupport::Concern

      included do
        include Rails.application.routes.url_helpers
        before_create :generate_referrer_token

        has_one :invitation, :foreign_key => :recipient_id, :class_name => "Referral"
        has_many :referrals, :foreign_key => :referrer_id
      end


      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      def update_referral(token)
        referral = Referral.find_by_referral_token(token)
        if referral && self != referral.referrer
          referral.update_attributes(:recipient_id => self.id,
                                     :registered_at => self.created_at)
        end
      end

      def referral_path(path=nil)

        unless self.referrer_token
          self.generate_referrer_token
          self.save!
        end

        unless path
          path = root_path
        end
        if path == "/"
          path = nil
        end
        referral_landing_path(:referrer_token=>self.referrer_token, :path=>path)
      end

      protected

      def generate_referrer_token
        self.referrer_token = Devise.friendly_token unless self.referrer_token
      end

      module ClassMethods
        Devise::Models.config(self, :referrer_types)
      end
    end
  end
end
