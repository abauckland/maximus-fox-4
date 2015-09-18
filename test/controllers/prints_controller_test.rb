require 'test_helper'

class PrintsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @controller = PrintsController.new
    @project_rev = projects(:CAWS_rev)
  end

#edit
  test "not authenticated should get redirect" do
    get :show, id: @project_rev.id
    assert_response :redirect
  end

  test "should show page if owner" do
    sign_in users(:owner)

    get :show, id: @project_rev.id
    assert_response :success
  end

end
