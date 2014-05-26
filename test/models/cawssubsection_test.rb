require 'test_helper'

class CawssubsectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     cawssubsection = Cawssubsection.new
     assert_respond_to(cawssubsection, :cawssection)
     assert_respond_to(cawssubsection, :subsections)
   end

#methods

##NESTED ATTRIBUTES FOR CAWSSECTION NOT WORKING
#   test "should combined full code" do
#      cawssubsection = Cawssubsection.new(:ref => 20, :text => "mytitle", :cawssection_id => 1)
#      assert_equal "MyString20", cawssubsection.full_code
#   end
 
#   test "should combined full code and title" do
#      cawssubsection = Cawssubsection.new(:ref => 20, :text => "mytitle", :cawssection_id => 1)
#      assert_equal "MyString20 mytitle", cawssubsection.full_code_and_title
#   end

   test "should combined part code and title" do
      cawssubsection = Cawssubsection.new(:ref => 20, :text => "mytitle")
      assert_equal "20 mytitle", cawssubsection.part_code_and_title
   end
   
end
