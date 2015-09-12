require 'test_helper'

class CawssectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     cawssection = Cawssection.new
     assert_respond_to(cawssection, :cawssubsections)
   end
   
#methods
   test "should combine ref and title" do
      cawssection = cawssections(:A)
      assert_equal "A Preliminaries", cawssection.code_and_title
   end
   
end
