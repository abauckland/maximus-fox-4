require 'test_helper'

class CompaniesControllerTest < ActionController::TestCase
  setup do
    @company = FactoryGirl.create(:company_with_user, check_field: '')
 #   session[:user_id] = FactoryGirl.build(:user).id
  end

#routes - duplication of tests below?
  test "should route to company" do
    assert_generates '/companies/'+@company.id.to_s+'/edit', {controller: "companies", action: "edit", id: @company.id}
    assert_generates '/companies/new', {controller: "companies", action: "new"}
  end

#authentication

  #test if current_user role is not "owner" redirects to log out if not
  #opposite of action/view test
#  it_requires_owner do
#    get :edit, id: @company
#  end



#actions/views
  #no user required to create new
  test "should get new" do
    get :new
    assert_response :success
    
    assert_template layout: "websites"
  end

#  test "should create company" do
#    assert_difference('Company.count') do
#      post :create, company: { reg_name: @company.reg_name, name: @company.name, no_licence: @company.no_licence, photo_content_type: @company.photo_content_type, photo_file_name: @company.photo_file_name, photo_file_size: @company.photo_file_size, photo_updated_at: @company.photo_updated_at, read_term: @company.read_term, reg_address: @company.reg_address, reg_location: @company.reg_location, reg_number: @company.reg_number, tel: @company.tel, category: @company.category, www: @company.www }
#    end

#    assert_redirected_to company_path(assigns(:company))
#  end


  #test if user and user role is "owner"
  test "should get edit" do
    get :edit, id: @company
    assert_response :success
    assert_template layout: "users"
  end

#  test "should update company" do
#    patch :update, id: @company, company: { reg_name: @company.reg_name, name: @company.name, no_licence: @company.no_licence, photo_content_type: @company.photo_content_type, photo_file_name: @company.photo_file_name, photo_file_size: @company.photo_file_size, photo_updated_at: @company.photo_updated_at, read_term: @company.read_term, reg_address: @company.reg_address, reg_location: @company.reg_location, reg_number: @company.reg_number, tel: @company.tel, category: @company.category, www: @company.www }
#    assert_redirected_to edit_company_path(id: @company)
#  end


end
