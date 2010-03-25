require 'test/test_helper'

class Referable < User
  devise :authenticatable, :referable, :referrer_types => [:foo, :bar]
end

class ActiveRecordTest < ActiveSupport::TestCase
  def include_module?(klass, mod)
    klass.devise_modules.include?(mod) &&
    klass.included_modules.include?(Devise::Models::const_get(mod.to_s.classify))
  end

  def assert_include_modules(klass, *modules)
    modules.each do |mod|
      assert include_module?(klass, mod), "#{klass} not include #{mod}"
    end

    (Devise::ALL - modules).each do |mod|
      assert_not include_module?(klass, mod), "#{klass} include #{mod}"
    end
  end

  test 'add referable module only' do
    assert_include_modules Referable, :authenticatable, :referable
  end

  test 'set a value for referrer_types' do
    assert_equal [:foo, :bar], Referable.referrer_types
  end
  

end
