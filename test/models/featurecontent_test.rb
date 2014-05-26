require 'test_helper'

class FeaturecontentTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     featurecontent = FactoryGirl.build_stubbed(:featurecontent)
     assert_respond_to(featurecontent, :feature)
   end
end
