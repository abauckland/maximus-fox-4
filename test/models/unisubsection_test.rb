require 'test_helper'

class UnisubsectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     unisubsection = Unisubsection.new
     assert_respond_to(unisubsection, :subsections)
     assert_respond_to(unisubsection, :unisection)
   end
end
