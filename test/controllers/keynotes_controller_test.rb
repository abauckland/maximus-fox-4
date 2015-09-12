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
#  test "should download document" do
#    sign_in users(:owner)
      
#    get :keynote_export, id: @project, cad_product: 'csv'
#    assert_response :success
#  end

#keynote_export: revit
#  test "should download document" do
#    sign_in users(:owner)
      
#    get :keynote_export, id: @project, cad_product: 'revit'
#    assert_response :success
#  end

#keynote_export: cadimage_keynote
#  test "should download document" do
#    sign_in users(:owner)
      
#    get :keynote_export, id: @project, cad_product: 'cadimage_keynote'
#    assert_response :success
#  end

end
