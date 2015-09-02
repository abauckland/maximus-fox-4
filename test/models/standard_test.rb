require 'test_helper'

class StandardTest < ActiveSupport::TestCase
#associations
   test "should be associated with valuetypes" do
     standard = Standard.new
     assert_respond_to(standard, :valuetypes)
   end
   
#methods
   test "should combined ref and title" do
      standard = standards(:one)
      assert_equal "MyString MyString", standard.ref_and_title
   end   
end
