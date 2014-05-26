require 'test_helper'

class CawssectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     cawssection = Cawssection.new
     assert_respond_to(cawssection, :cawssubsections)
   end
   
#methods
   test "should combined ref and title" do
      cawssection = Cawssection.new(:ref => "T", :text => "test")
      assert_equal "T test", cawssection.code_and_title
   end
   
end
