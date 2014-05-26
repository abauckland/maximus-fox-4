require 'test_helper'

class AlterationTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     alteration = Alteration.new
     assert_respond_to(alteration, :revision)
     assert_respond_to(alteration, :project)
     assert_respond_to(alteration, :clause)
     assert_respond_to(alteration, :txt1)
     assert_respond_to(alteration, :txt2)
     assert_respond_to(alteration, :txt3)
     assert_respond_to(alteration, :txt4)
     assert_respond_to(alteration, :txt5)
     assert_respond_to(alteration, :txt6)
     assert_respond_to(alteration, :identity)
     assert_respond_to(alteration, :perform)
     assert_respond_to(alteration, :linetype)     
     assert_respond_to(alteration, :specline)
     assert_respond_to(alteration, :user)
   end
end
