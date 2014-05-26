require 'test_helper'

class PerformkeyTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     performkey = Performkey.new
     assert_respond_to(performkey, :performs)       
   end
end
