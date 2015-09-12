require 'test_helper'

class GuidenoteTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     guidenote = Guidenote.new
     assert_respond_to(guidenote, :clauseguides)
   end


#vaildations
   test "should not save note with same text" do
      guidenote = Guidenote.create(text: "<p>guide text sample one<p>")
      assert_not guidenote.valid?
      assert_equal [": A guide with the same description already exists for the company"], guidenote.errors.messages[:text]
   end

end
