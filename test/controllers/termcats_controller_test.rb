require 'test_helper'

class TermcatsControllerTest < ActionController::TestCase

  setup do
    @termcat = termcats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:termcats)
  end

end
