require 'test_helper'

class SubsectionTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     subsecton = Subsection.new
     assert_respond_to(subsecton, :subsectionusers)
     assert_respond_to(subsecton, :clauserefs)
     assert_respond_to(subsecton, :cawssubsection)
     assert_respond_to(subsecton, :unisubsection)
   end
end