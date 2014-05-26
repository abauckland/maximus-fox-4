require 'test_helper'

class FeatureTest < ActiveSupport::TestCase
#associations
   test "should have associations" do
     feature = FactoryGirl.build_stubbed(:feature)
     assert_respond_to(feature, :featurecontents)
   end
end
