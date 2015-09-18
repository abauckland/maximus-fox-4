require 'test_helper'

class SpeclinesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @specline = speclines(:specline_2) #CAWS
    @specline_rev = speclines(:specline_42) #CAWS_rev
  end

#new_specline
  #check line is added
  #check revision is not recorded
  #check revision is recorded

  test "should add new line" do
    sign_in users(:admin)
    assert_difference('Specline.count') do
      xhr :get, :new_specline, format: :js, id: @specline.id
    end
    assert_response :success
  end

  test "should add line but not add alteration record" do
    sign_in users(:admin)
    assert_no_difference('Alteration.count') do
      xhr :get, :new_specline, format: :js, id: @specline.id
    end
    assert_response :success
  end

#no previous changes to line
  test "should add line and alteration record" do
    sign_in users(:admin)
    assert_difference('Alteration.count', +1) do
      xhr :get, :new_specline, format: :js, id: @specline_rev.id
    end
    assert_response :success
  end

#matches previously deleted line
#one less change record
#TODO matches based on linetype as well as other parameters
  test "should add line and remove previous alteration record" do
    sign_in users(:admin)
    assert_difference('Alteration.count', -1) do
      xhr :get, :new_specline, format: :js, id: 46
    end
    assert_response :success
  end

#matches previously changed line (old value)
#no change in number of change records
#create 'new' change record
#TODO matches based on linetype as well as other parameters
  test "should add line and amend change alteration record" do
    sign_in users(:admin)
    assert_no_difference('Alteration.count') do
      xhr :get, :new_specline, format: :js, id: 41
    end
    assert_response :success
  end


#matches previously changed line (current value)
#no change in number of change records
#create change record
#TODO matches based on linetype as well as other parameters
  test "should add line and new alteration record" do
    sign_in users(:admin)
    assert_difference('Alteration.count', +1) do
      xhr :get, :new_specline, format: :js, id: 42
    end
    assert_response :success
  end




#move_specline
  #check line is moved within clause
  #check line is moved between clauses
  #check alteration is recorded is moved between clauses

  test "should move line up one clauseline ref" do
    sign_in users(:admin)

    xhr :put, :move_specline, format: :js, id: @specline.id, table_id_array: "1,2,9,3,4,5,6,7,8,10"

    assert_response :success
  end

#  test "should move line up one clauseline ref" do
#  end

#  test "should move line up one clause" do
#  end

#  test "should move line up one clause and record change" do
#  end


#edit
  test "should list linetypes" do
    sign_in users(:owner)

    xhr :get, :edit, format: :js, id: @specline.id

    assert_response :success
  end


#update_specline_3
  test "should update txt3" do
    sign_in users(:owner)
    xhr :put, :update_specline_3, format: :js, id: @specline.id, value: "new test text"
    assert_response :success
  end


#update_specline_4
  test "should update txt4" do
    sign_in users(:owner)
    xhr :put, :update_specline_4, format: :js, id: @specline.id, value: "new test text"
    assert_response :success
  end

#update specline 4 - no revision recording
  test "should update txt4 and not add alteration record" do
    sign_in users(:owner)
    assert_no_difference('Alteration.count') do
      xhr :put, :update_specline_4, format: :js, id: @specline.id, value: "new test text"
    end
    assert_response :success
  end

#record change where no previous change to line
  test "should update txt4 and add change record" do
    sign_in users(:owner)
    assert_difference('Alteration.count', +1) do
      xhr :put, :update_specline_4, format: :js, id: 44, value: "new test text"
    end
    assert_response :success
  end

#change to existing new line
  test "should update txt4 and update existing new record" do
    sign_in users(:owner)
    assert_no_difference('Alteration.count') do
      xhr :put, :update_specline_4, format: :js, id: 46, value: "new test text"
    end
    assert_response :success
  end

#record change where previous change to line
  test "should update txt4 and update existing change record" do
    sign_in users(:owner)
    assert_no_difference('Alteration.count') do
      xhr :put, :update_specline_4, format: :js, id: 42, value: "new test text"
    end
    assert_response :success
  end

#change from value matches value of new line
#+0 alteration

#change to value matches value of new line
#+1 alteration

#change from value matches value of deleted line
#+1 alteration

#change to value matches value of deleted line
#+0 alteration

#change to value matches change to value of changed line
#changed from value matches change from value of changed line
#both above have same outcome
#+1 alteration

#change from value matches change to value of changed line
#+0 alteration

#changed to value matches change from value of changed line
#+1 alteration

#change from value matches change from value of changed line
#& change to value matches change to value of changed line
#-1 alteration


#update_specline_5
  test "should update txt5" do
    sign_in users(:owner)
    xhr :put, :update_specline_5, format: :js, id: @specline.id, value: "new test text"
    assert_response :success
  end


#update
#  test "should update linetype" do
#  end

#update line if revisions being recorded and no previous change to the line


#delete_clause
  test "should remove lines" do
    sign_in users(:owner)
    @clause_line = speclines(:specline_1)
    assert_difference('Specline.count', -7) do #number of fixture lines in clause
      xhr :delete, :delete_clause, format: :js, id: @clause_line.id
    end
    assert_response :success
  end

#  test "should remove lines and alteration record" do
#  end


#delete_specline
  test "should remove line" do
    sign_in users(:owner)
    assert_difference('Specline.count', -1) do
      xhr :delete, :delete_specline, format: :js, id: @specline.id
    end
    assert_response :success
  end

#no previous changes to line
#  test "should remove line and add alteration record" do
#    sign_in users(:owner)
#    assert_difference('Alteration.count', +1) do
#      xhr :delete, :delete_specline, format: :js, id: @specline_rev.id
#    end
#    assert_response :success
#  end

#if previous new line record
#TODO add matching record to alterations table
#  test "should remove line and previous new alteration record" do
#    sign_in users(:owner)
#    assert_difference('Alteration.count', -1) do
#      xhr :delete, :delete_specline, format: :js, id: @specline_rev.id
#    end
#    assert_response :success
#  end

#if previous change line record
#TODO add matching record to alterations table
#  test "should remove line and previous change alteration record" do
#    sign_in users(:owner)
#    assert_no_difference('Alteration.count', -1) do
#      xhr :delete, :delete_specline, format: :js, id: @specline_rev.id
#    end
#    assert_response :success
#  end





#move_up
#move_down
#xref_data
#update_product_key
#update_product_value
#guidance

end
