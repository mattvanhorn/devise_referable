ENV["RAILS_ENV"] = "test"
require File.join(File.dirname(__FILE__), 'rails_app', 'config', 'environment')

require 'test_help'
require 'mocha'
require 'webrat'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Schema.define(:version => 1) do
  create_table :users do |t|
    t.authenticatable :null => true
    t.registerable
    t.string :username
    t.timestamps
  end
  
  create_table :blogs do |t|
    t.string :name
    t.string :referrer_token, :default => 'abc123'
    t.timestamps
  end
  
  create_table :referrals, :force => true do |t|
    t.integer   :referrer_id
    t.string    :referrer_type
    t.integer   :recipient_id
    t.string    :referral_token
    t.datetime  :registered_at
    t.timestamps
  end
end

class Blog
end

class User
  devise :authenticatable, :registerable, :referable, :referrer_types => [:blog]
end

ActionController::Routing::Routes.draw do |map|
  map.devise_for :users
end

require File.join(File.dirname(__FILE__), '..', 'app', 'controllers', 'referrals_controller')
# require File.join(File.dirname(__FILE__), '..', 'app', 'models', 'referral')

Webrat.configure do |config|
  config.mode = :rails
  config.open_error_files = false
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  def assert_not(assertion, message = nil)
    assert !assertion, message
  end

  def assert_not_blank(assertion)
    assert !assertion.blank?
  end
  alias :assert_present :assert_not_blank
end
