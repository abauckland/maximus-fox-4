require 'test_helper'

class Txt2Test < ActiveSupport::TestCase
   test "should have associations" do
     txt2 = Txt2.new
     assert_respond_to(txt2, :speclines)
     assert_respond_to(txt2, :alterations)
   end
end
