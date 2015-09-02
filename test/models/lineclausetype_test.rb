require 'test_helper'

class LineclaustypeTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     lineclaustype = Lineclaustype.new
     assert_respond_to(lineclaustype, :clausetype)
     assert_respond_to(lineclaustype, :linetype)
   end
end
