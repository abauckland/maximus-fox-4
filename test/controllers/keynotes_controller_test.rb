require 'test_helper'

class KeynotesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
  end

#authorization
  test "not authenticated should get redirect" do
    get :show, id: @project
    assert_response :redirect

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


#  test "if user role is read only should get redirect" do
#    sign_in users(:employee_2)

#    get :show, id: @project
#    assert_response 403
#  end


#show
  test "if user role is not read show print options" do
    sign_in users(:owner)

    get :show, id: @project
    assert_response :success
  end


#keynote_export: csv_keynote
  test "should download csv" do
    sign_in users(:owner)

    get :keynote_export, format: :csv, id: @project, cad_product: 'csv'
    assert_response :success
    assert_equal "text/csv", response.content_type

#  csv = CSV.parse response.body # Let raise if invalid CSV
#  assert csv
#  assert_equal 6, csv.size
#  assert_equal "Joe Smith", csv[3][4]

  end

#keynote_export: revit
  test "should download revit keynotes" do
    sign_in users(:owner)

    get :keynote_export, format: :txt, id: @project, cad_product: 'revit'
    assert_response :success
  end

#keynote_export: cadimage_keynote
  test "should download  cadimage csv" do
    sign_in users(:owner)

    get :keynote_export, format: :csv, id: @project, cad_product: 'cadimage'
    assert_response :success
  end

#keynote_export: cadimage_keynote
  test "should download  cadimage keynotes" do
    sign_in users(:owner)

    get :keynote_export, format: :xml, id: @project, cad_product: 'cadimage_keynote'
    assert_response :success
  end

end
