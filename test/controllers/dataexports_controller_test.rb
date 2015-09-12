require 'test_helper'

class DataexportsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
  end

#authorization
  test "not authenticated should get redirect" do
    get :show, id: @project
    assert_response :redirect
  end


#show
  test "should get show" do
    sign_in users(:admin) #fixture set as manage role

    get :show, id: @project.id
    assert_response :success
  end


#download, products and accessories
#  test "should download csv file" do
#    get :download, id: @project, product_data: 'products_accessories'
#    assert_response :success
#  end


#download, products
#  test "should download csv file" do
#    get :download, id: @project, product_data: 'products'
#    assert_response :success
#  end

end