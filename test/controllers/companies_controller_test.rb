require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @company = companies(:specright)
  end


#edit
  test "not authenticated should get redirect" do
    get :edit, id: @company.id
    assert_response :redirect
  end

  test "if user role is not owner should get redirect" do
    sign_in users(:employee_1)

    get :edit, id: @company.id
    assert_response 403
  end

  #test if user and user role is admin"
  test "should get edit if admin" do
    sign_in users(:admin)

    get :edit, id: @company.id
    assert_response :success
    assert_template layout: "users"
  end

  #test if user and user role is "owner"
  test "should get edit if owner" do
    sign_in users(:owner)

    get :edit, id: @company.id
    assert_response :success
    assert_template layout: "users"
  end

#update
#  test "not authenticated should get redirect" do
#    patch :update, id: @company.id
#    assert_response :redirect
#  end

#  test "if user role is not owner should get redirect" do
#    sign_in users(:employee_1)

#    patch :update, id: @company.id
#    assert_response 403
#  end


#  test "should update company" do
#    sign_in users(:owner)

#    patch :update, id: @company, company: { reg_name: @company.reg_name, name: @company.name, no_licence: @company.no_licence, photo_content_type: @company.photo_content_type, photo_file_name: @company.photo_file_name, photo_file_size: @company.photo_file_size, photo_updated_at: @company.photo_updated_at, read_term: @company.read_term, reg_address: @company.reg_address, reg_location: @company.reg_location, reg_number: @company.reg_number, tel: @company.tel, category: @company.category, www: @company.www }
#    assert_redirected_to edit_company_path(id: @company)
#  end


end
