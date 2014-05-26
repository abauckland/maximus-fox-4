require 'test_helper'

class PriceplansControllerTest < ActionController::TestCase
  setup do
    @priceplan = FactoryGirl.create(:priceplan)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:priceplans)
  end

end
