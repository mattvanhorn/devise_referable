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
    #  - The referral_token is also stored in the session
    #  - The visitor is then redirected to the path appended to the referral_landing_path (i.e. /path/to/destination above)
    #  - If no path is given, they're redirected to the root path.
    #  - If the visitor registers during the session, the referral record is updated with the new user id, and the session token is cleared.
    # 
    # Configuration:
    # 
    #   referrer_types: an array of symbols for classes that can refer users. i.e. [:blog, :customer, :user]
    #   
    module Referable

      def self.included(base)
        base.class_eval do
          has_one :referral, :foreign_key => :recipient_id
          extend ClassMethods
        end
      end

      def update_referral(token)
        referral = Referral.find_by_referral_token(token)
        if referral
          referral.update_attributes( :recipient_id => self.id, 
                                      :registered_at => self.created_at )
        end
      end
      
      protected

      module ClassMethods
        Devise::Models.config(self, :referrer_types)
      end
    end
  end
end
