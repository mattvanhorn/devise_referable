require 'devise/hooks/referable'

module Devise
  module Referable
    module Referral

      def self.included(base)
        base.extend(ClassMethods)
      end

      module InstanceMethods
        def generate_token
          self.referral_token ||= Devise.friendly_token
        end
      end

      module ClassMethods
        def acts_as_referral(options = {})
          class_eval <<-EOV
            include Devise::Referable::Referral::InstanceMethods

            def self.referrer_types
              User.referrer_types
            end

            def self.lookup_referrer(token)
              unless token.blank?
                referrer_types.map{ |type| type.to_s.classify.constantize }.each do |klass|
                  ref = klass.find_by_referrer_token(token)
                  return ref unless ref.nil?
                end
              end
              return nil
            end

            def self.from_token(token, options={})
                sender = lookup_referrer(token)
                if sender

                  #if there is already a referral for the given anonymous user
                  if options[:session_id] and ref=self.find_by_session_id_and_referrer_id(options[:session_id], sender.id)
                    ref
                  else
                    self.create do |ref|
                      ref.referrer = sender
                      ref.session_id=options[:session_id]
                    end
                  end

                end
            end


            belongs_to :referrer, :polymorphic => true
            belongs_to :recipient, :class_name => 'User'
            before_create :generate_token
            
          EOV
        end
      end
    end
  end
end



