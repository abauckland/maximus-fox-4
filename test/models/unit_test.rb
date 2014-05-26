require 'test_helper'

class UnitTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     unit = Unit.new
     assert_respond_to(unit, :valuetypes)
   end
end
