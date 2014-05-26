require 'test_helper'

class SpeclineTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     specline = Specline.new
     assert_respond_to(specline, :alterations)
     assert_respond_to(specline, :project)
     assert_respond_to(specline, :clause)
     assert_respond_to(specline, :txt1)
     assert_respond_to(specline, :txt2)
     assert_respond_to(specline, :txt3)
     assert_respond_to(specline, :txt4)
     assert_respond_to(specline, :txt5)
     assert_respond_to(specline, :txt6)
     assert_respond_to(specline, :identity)
     assert_respond_to(specline, :perform)
     assert_respond_to(specline, :linetype)
   end
end
