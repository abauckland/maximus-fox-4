require 'test_helper'

class InstanceTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     instance = Instance.new
     assert_respond_to(instance, :charcs)
     assert_respond_to(instance, :performs)
     assert_respond_to(instance, :product)
   end
end