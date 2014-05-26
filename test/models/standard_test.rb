require 'test_helper'

class StandardTest < ActiveSupport::TestCase
#associations
   test "should be associated with valuetypes" do
     standard = Standard.new
     assert_respond_to(standard, :valuetypes)
   end
   
#methods
   test "should combined ref and title" do
      standard = Standard.new(:ref => "myref", :title => "mytitle")
      assert_equal "myref mytitle", standard.ref_and_title
   end   
end
