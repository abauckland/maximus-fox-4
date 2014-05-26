require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
    session[:user_id] = users(:one).id
  end

  it_requires_authentication do
    get :edit, id: @user
  end

  #test if current_user role is not "owner" redirects to log out if not
  #opposite of action/view test
  it_requires_owner do
    get :index
  end


  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end


  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { api_key: @user.api_key, company_id: @user.company_id, email: @user.email, first_name: @user.first_name, password_hash: @user.password_hash, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, password_salt: @user.password_salt, role: @user.role, surname: @user.surname, failed_attempts: @user.failed_attempts, locked_at: @user.locked_at, number_times_logged_in: @user.number_times_logged_in, active: @user.active, last_sign_in: @user.last_sign_in, ip: @user.ip}
    end

    assert_redirected_to :index
  end


  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { api_key: @user.api_key, company_id: @user.company_id, email: @user.email, first_name: @user.first_name, password_hash: @user.password_hash, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, password_salt: @user.password_salt, role: @user.role, surname: @user.surname, failed_attempts: @user.failed_attempts, locked_at: @user.locked_at, number_times_logged_in: @user.number_times_logged_in, active: @user.active, last_sign_in: @user.last_sign_in, ip: @user.ip}
    assert_redirected_to user_path(assigns(:user))
  end

end
