require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = companies(:one)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company" do
    assert_difference('Company.count') do
      post :create, company: { reg_name: @company.reg_name, name: @company.name, no_licence: @company.no_licence, photo_content_type: @company.photo_content_type, photo_file_name: @company.photo_file_name, photo_file_size: @company.photo_file_size, photo_updated_at: @company.photo_updated_at, read_term: @company.read_term, reg_address: @company.reg_address, reg_location: @company.reg_location, reg_number: @company.reg_number, tel: @company.tel, category: @company.category, www: @company.www }
    end

    assert_redirected_to company_path(assigns(:company))
  end


  test "should get edit" do
    get :edit, id: @company
    assert_response :success
  end

  test "should update company" do
    patch :update, id: @company, company: { reg_name: @company.reg_name, name: @company.name, no_licence: @company.no_licence, photo_content_type: @company.photo_content_type, photo_file_name: @company.photo_file_name, photo_file_size: @company.photo_file_size, photo_updated_at: @company.photo_updated_at, read_term: @company.read_term, reg_address: @company.reg_address, reg_location: @company.reg_location, reg_number: @company.reg_number, tel: @company.tel, category: @company.category, www: @company.www }
    assert_redirected_to company_path(assigns(:company))
  end

end
