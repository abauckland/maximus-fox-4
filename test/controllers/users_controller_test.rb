require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { api_key: @user.api_key, company_id: @user.company_id, email: @user.email, first_name: @user.first_name, password_hash: @user.password_hash, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, password_salt: @user.password_salt, role: @user.role, surname: @user.surname }
    end

    assert_redirected_to user_path(assigns(:user))
  end


  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, user: { api_key: @user.api_key, company_id: @user.company_id, email: @user.email, first_name: @user.first_name, password_hash: @user.password_hash, password_reset_sent_at: @user.password_reset_sent_at, password_reset_token: @user.password_reset_token, password_salt: @user.password_salt, role: @user.role, surname: @user.surname }
    assert_redirected_to user_path(assigns(:user))
  end

end
