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

    # admin users can create, delete and edit options
    assert_select "#primary_project",     count: 1
    assert_select "#sub_select_project",  count: 1
    assert_select "#sub_new_project",     count: 1
    assert_select "#sub_edit_project",    count: 1
    assert_select "#sub_project_users",   count: 0

    assert_select "#primary_document",    count: 1
    assert_select "#primary_revisions",   count: 1
    assert_select "#primary_publish",     count: 1
    assert_select "#sub_print",           count: 1
    assert_select "#sub_printsetting",    count: 1
    assert_select "#sub_keynote",         count: 1
    assert_select "#sub_data_export",     count: 0

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
