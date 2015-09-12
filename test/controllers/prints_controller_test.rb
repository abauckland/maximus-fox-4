require 'test_helper'

class PrintsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
  end

#authorization
  test "not authenticated should get redirect" do
    get :show, id: @project
    assert_response :redirect
  end

#  test "if user role is not manager should get redirect" do
#    sign_in users(:employee_2)
#
#    get :show, id: @project
#    assert_response 403
#  end


#show
  test "if user role is not read show print options" do
    sign_in users(:owner)

    get :show, id: @project
    assert_response :success
  end


#print_project
#  test "should download document" do
#    sign_in users(:manage)

#    get :print_project, id: @project, issue: 'final'
#    assert_response :success
#  end

end
