require 'test_helper'

class LineclaustypeTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     lineclaustype = FactoryGirl.build_stubbed(:lineclausetype)
     assert_respond_to(lineclaustype, :clausetype)
     assert_respond_to(lineclaustype, :linetype)
   end
end
