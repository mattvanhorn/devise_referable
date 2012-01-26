Devise.module_eval do
  # list of classes that can act as referrer.
  mattr_accessor :referrer_types
  @@referrer_types = []
end

Devise.add_module :referable, :controller => :referrals, :model=>'devise/models/referable'


module DeviseReferable;end

require 'devise_referable/routes'
require 'devise_referable/referral'
