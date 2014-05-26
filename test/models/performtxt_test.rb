require 'test_helper'

class PerformtxtTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     performtxt = Performtxt.new
     assert_respond_to(performtxt, :performvalues)
   end
end
