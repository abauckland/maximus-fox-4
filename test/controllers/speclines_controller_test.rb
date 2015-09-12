require 'test_helper'

class SpeclinesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @specline = speclines(:specline_1)
  end

#new_specline
#  test "should add new line" do
    #add line
    #check clauseline ref
    #check prefix
#  end

#  test "should create clauseguide" do
#    sign_in users(:owner)
#    assert_difference('Specline.count') do
#      post :create, specline: {}
#    end
    #redirect to index if saved
#    assert_redirected_to clauseguides_path
#  end


  test "should destroy specline" do
    sign_in users(:admin)
    assert_difference('Specline.count', -1) do
      delete :delete_specline, id: @specline
    end

#    assert_redirected_to clauseguides_path
  end



#  test "should add new line and alteration record" do
    #add line
    #check clauseline ref
    #check prefix
    #check if alteration record created
#  end


#move_specline
#  test "should move line up one clauseline ref" do
#  end

#  test "should move line up one clauseline ref" do
#  end

#  test "should move line up one clause" do
#  end

#  test "should move line up one clause and record change" do
#  end


#edit
#  test "should show list of linetypes" do
#  end


#update_specline_3
#  test "should update line" do
#  end

#  test "should update line and new text record" do
#  end

#  test "should update line and alteration record" do
#  end

#update_specline_4
#  test "should update line" do
#  end

#update_specline_5
#  test "should update line" do
#  end


#update
#  test "should update linetype" do
#  end


#delete_clause
#  test "should remove lines" do
#  end

#  test "should remove lines and alteration record" do
#  end


#delete_specline
#  test "should remove line" do
#  end

#  test "should remove line and alteration record" do
#  end


#move_up
#move_down
#xref_data
#update_product_key
#update_product_value
#guidance

end
