require 'test_helper'

class SubsectonTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     subsecton = Subsecton.new
     assert_respond_to(subsecton, :subsectionusers)
     assert_respond_to(subsecton, :clauserefs)
     assert_respond_to(subsecton, :cawssubsection)
     assert_respond_to(subsecton, :unisubsection)
   end
end