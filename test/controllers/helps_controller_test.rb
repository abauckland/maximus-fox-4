require 'test_helper'

class HelpsControllerTest < ActionController::TestCase
  setup do
    @tutorial = helps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutorials)
  end

  test "should show help" do
    get :show, id: @tutorial

  end

end
