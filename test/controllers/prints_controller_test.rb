require 'test_helper'

class PrintsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
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


#print_project
  test "should download draft document" do
    sign_in users(:owner)
    get :print_project, format: :pdf, id: @project_rev.id, issue: 'draft'
    assert_response :success
    assert_equal "application/pdf", response.content_type
  end


  test "should download final document" do
    sign_in users(:owner)
    get :print_project, format: :pdf, id: @project_rev.id, issue: 'final'
    assert_response :success
    assert_equal "application/pdf", response.content_type
  end

end
