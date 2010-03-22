require 'devise_referable'

ActiveRecord::Base.class_eval { include Devise::Referable::Referral }