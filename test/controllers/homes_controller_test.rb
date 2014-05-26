require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  setup do
    @home = FactoryGirl.build_stubbed(:home)
  end

  test "should get index" do
    get :index
    assert_response :success
    
    assert_not_nil assigns(:home)
  end

end
