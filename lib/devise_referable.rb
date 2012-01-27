Devise.add_module :referable, :controller => :referrals, :model=>'devise/models/referable'


module DeviseReferable;end

require 'devise_referable/routes'
require 'devise_referable/referral'
