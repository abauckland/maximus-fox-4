require 'test_helper'

class PerformvalueTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     performvalue = Performvalue.new
     assert_respond_to(performvalue, :performs)
     assert_respond_to(performvalue, :performtxt)
     assert_respond_to(performvalue, :valuetype)
   end

#method
  #value_with_units


end
