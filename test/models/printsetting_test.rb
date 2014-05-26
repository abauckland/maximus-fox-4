require 'test_helper'

class PrintsettingTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     printsetting = Printsetting.new
     assert_respond_to(printsetting, :project)
   end
end
