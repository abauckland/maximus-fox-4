require 'test_helper'

class PriceplansControllerTest < ActionController::TestCase
  setup do
    @priceplan = priceplans(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:priceplans)
  end

end
