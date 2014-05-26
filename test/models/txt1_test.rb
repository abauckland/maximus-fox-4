require 'test_helper'

class Txt1Test < ActiveSupport::TestCase
   test "should have associations" do
     txt1 = Txt1.new
     assert_respond_to(txt1, :speclines)
     assert_respond_to(txt1, :alterations)
   end
end
