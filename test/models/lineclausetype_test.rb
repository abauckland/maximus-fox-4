require 'test_helper'

class LineclausetypeTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     lineclaustype = Lineclausetype.new
     assert_respond_to(lineclaustype, :clausetype)
     assert_respond_to(lineclaustype, :linetype)
   end
end
