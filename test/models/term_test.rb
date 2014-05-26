require 'test_helper'

class TermTest < ActiveSupport::TestCase
   test "should have associations" do
     term = Term.new
     assert_respond_to(term, :termcat)
   end
end
