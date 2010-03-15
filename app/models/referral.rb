require 'devise/hooks/referable'

class Referral < ActiveRecord::Base
  belongs_to :referrer, :polymorphic => true
  belongs_to :recipient, :class_name => 'User'
  
  before_create :generate_token
  
  class << self
    def referrer_types
      User.referrer_types
    end

    def lookup_referrer(token)
      unless token.blank?
        referrer_types.map{ |type| type.to_s.classify.constantize }.each do |klass|
          ref = klass.find_by_referrer_token(token)
          return ref unless ref.nil?
        end
      end
      return nil
    end

    def from_token(token)
      sender = lookup_referrer(token)
      if sender
        Referral.create do |ref|
          ref.referrer = sender
        end
      end
    end
  end
  
  def generate_token
    self.referral_token ||= Devise.friendly_token
  end
  
end