require 'test_helper'

class TermcatTest < ActiveSupport::TestCase
   test "should have associations" do
     termcat = Termcat.new
     assert_respond_to(termcat, :terms)
   end
end
