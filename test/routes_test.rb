require 'test/test_helper'

class MapRoutingTest < ActionController::TestCase

  test 'map referral ' do
    assert_recognizes({:controller => 'referrals', :action => 'create', :referrer_token => 'abc123', :path => []}, {:path => 'ref/abc123/', :method => :get})
  end
  
  test 'map referral landing' do
    assert_recognizes({:controller => 'referrals', :action => 'create', :referrer_token => 'abc123', :path => []}, {:path => 'ref/abc123/', :method => :get})
  end
  
  test 'map referral landing with path' do
    assert_recognizes({:controller => 'referrals', :action => 'create', :referrer_token => 'abc123', :path => %w(some path here)}, {:path => 'ref/abc123/some/path/here', :method => :get})
  end
  
  test 'map referral landing with no path' do
    assert_recognizes({:controller => 'referrals', :action => 'create', :referrer_token => 'abc123', :path => []}, {:path => 'ref/abc123', :method => :get})
  end

end
