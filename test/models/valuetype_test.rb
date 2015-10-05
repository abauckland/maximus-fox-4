require 'test_helper'

class ValuetypeTest < ActiveSupport::TestCase
#associations
   test "should be associated with performvalues, unit, standard" do
     valuetype = Valuetype.new
     assert_respond_to(valuetype, :performvalues)
     assert_respond_to(valuetype, :unit)
     assert_respond_to(valuetype, :standard)
   end


#test response if no unit_id
   test "should return unit text" do
      valuetype = valuetypes(:one)
      assert_equal "mm", valuetype.unit_text
   end

   test "should not return unit text" do
      valuetype = valuetypes(:two)
      assert_equal "", valuetype.unit_text
   end

#test response if no unit_id
   test "should return standard ref" do
      valuetype = valuetypes(:one)
      assert_equal "BS8000", valuetype.standard_ref
   end

#test response if no unit_id
   test "should return standard ref plus text prefix" do
      valuetype = valuetypes(:one)
      assert_equal " to BS8000", valuetype.to_standard_ref
   end

   test "should not return standard ref plus text prefix" do
      valuetype = valuetypes(:three)
      assert_equal "", valuetype.to_standard_ref
   end


end
