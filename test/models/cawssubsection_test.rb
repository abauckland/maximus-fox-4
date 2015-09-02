require 'test_helper'

class CawssubsectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     cawssubsection = Cawssubsection.new
     assert_respond_to(cawssubsection, :cawssection)
     assert_respond_to(cawssubsection, :subsections)
   end

#methods
   test "should combined full code" do
      cawssubsection = cawssubsections(:A10)
      assert_equal "A10", cawssubsection.full_code
   end
 
   test "should combined full code and title" do
      cawssubsection = cawssubsections(:A10)
      assert_equal "A10 Project Details", cawssubsection.full_code_and_title
   end

   test "should combined part code and title" do
      cawssubsection = cawssubsections(:A10)
      assert_equal "10 Project Details", cawssubsection.part_code_and_title
   end
   
end
