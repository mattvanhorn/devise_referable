require 'test/test_helper'
require 'test/model_tests_helper'

class ReferableTest < ActiveSupport::TestCase
  def setup
  end
  
  test 'should look up referrer' do
    blog = mock()
    Blog.expects(:find_by_referrer_token).with('abc123').returns(blog)
    assert Referral.lookup_referrer('abc123') == blog
  end
  
  test 'should return nil if no referrer is found' do
    Blog.expects(:find_by_referrer_token).with('abc123').returns(nil)
    assert_nil Referral.lookup_referrer('abc123')
  end
  
  test 'should create referral from token' do
    Blog.expects(:find_by_referrer_token).with('abc123').returns(create_user) # I just need an AR obj here to avoid massive stubbing. 
                                                                              # Should be a blog not a user.
    result = Referral.from_token('abc123')
    assert result.is_a?( Referral)
    assert_not_nil result.referral_token
    assert_not_nil result.referrer_id
    assert_not_nil result.referrer_type
    assert !result.new_record?
  end
  
  test 'should never generate the same referral token for different users' do
    referral_tokens = []
    10.times do
      ref = new_referral(:referrer_id => 1, :referrer_type => 'Publisher')
      token = ref.generate_token
      assert !referral_tokens.include?(token)
      referral_tokens << token
    end
  end

end
