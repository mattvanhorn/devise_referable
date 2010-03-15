class User < ActiveRecord::Base
  devise :authenticatable, :registerable, :recoverable, :rememberable, :validatable
  attr_accessible :username, :email, :password, :password_confirmation
end
