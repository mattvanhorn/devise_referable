Devise.module_eval do
  # list of classes that can act as referrer.
  mattr_accessor :referrer_types
  @@referrer_types = []
end
Devise.add_module :referable, :controller => :referrals, :model => 'devise_referable/model'

module DeviseReferable; end

require File.join(File.dirname(__FILE__), '..', 'app', 'models', 'referral')

require 'devise_referable/routes'
