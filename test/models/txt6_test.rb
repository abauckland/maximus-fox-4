require 'test_helper'

class Txt6Test < ActiveSupport::TestCase
#associations
   test "should have associations" do
     txt6 = Txt6.new
     assert_respond_to(txt6, :speclines)
     assert_respond_to(txt6, :alterations)
   end
end
