require 'test/test_helper'
require 'test/integration_tests_helper'

class ReferralTest < ActionController::IntegrationTest

  def setup
    @blog = Blog.create!(:name => 'Referrer', :referrer_token => 'abc123')
  end

  test 'new users should get referral records' do
    assert_equal 0, Referral.count
    visit referral_landing_path(:referrer_token => 'abc123')
    assert :success
    assert_equal 1, Referral.count
    assert_not_nil session[:referral_token]
    
    visit new_user_registration_path
    assert :success
    
    fill_in 'email', :with => 'new_user@test.com'
    fill_in 'password', :with => 'new_user123'
    fill_in 'password confirmation', :with => 'new_user123'
    click_button 'Sign up'
    
    user = User.last :order => "id"

    assert user.referral.referrer == @blog
  end

  test 'existing users should not get referral records' do
    assert_equal 0, Referral.count
    
    visit new_user_registration_path
    assert :success
    
    fill_in 'email', :with => 'new_user@test.com'
    fill_in 'password', :with => 'new_user123'
    fill_in 'password confirmation', :with => 'new_user123'
    click_button 'Sign up'
    assert :success
    
    visit '/ref/abc123'
    assert :success
    
    user = User.last :order => "id"
    assert_equal 0, Referral.count
    assert_nil user.referral
  end

  test 'referral lookup failures should be ignored' do
    assert_equal 0, Referral.count
    visit referral_landing_path(:referrer_token => 'bogus')
    assert :success
    
    assert_equal 0, Referral.count
    assert_nil session[:referral_token]
  end
  
end
