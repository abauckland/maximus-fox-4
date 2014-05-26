require 'test_helper'

class ValuetypeTest < ActiveSupport::TestCase
#associations
   test "should be associated with performvalues, unit, standard" do
     valuetype = Valuetype.new
     assert_respond_to(valuetype, :performvalues)
     assert_respond_to(valuetype, :unit)
     assert_respond_to(valuetype, :standard)
   end
end
