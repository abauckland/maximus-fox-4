require 'test_helper'

class ClauseguidesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @clauseguide = clauseguides(:one)
  end

#index
  test "not authenticated should get redirect" do
    get :index
    assert_response :redirect
  end

  test "if user role is not admin should get redirect" do
    sign_in users(:owner)

    get :index
    assert_response 403
  end

  test "if user role is admin show list of clauses and guide status" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:clauses)
    assert_not_nil assigns(:subsections)
    assert_not_nil assigns(:selected_subsection)

    # admin users can create, delete and edit options
    #number of clauses without guide
#    assert_select ".line_new_icon", count: 1
#    assert_select ".line_insert_icon", count: 1 #link to clone action
    #number of clauses with guide
#    assert_select ".line_edit_icon", count: 2
#    assert_select ".line_delete_icon", count: 2
#    assert_select ".line_menu_icon", count: 2 #link to assign action
  end




  test "should get new" do
    sign_in users(:admin)
    get :new, clause_id: 1, plan_id: 1

    assert_not_nil assigns(:clauseguide)
    assert_not_nil assigns(:plan_id)
    assert_not_nil assigns(:clause_id)

    assert_response :success
  end


  test "should create clauseguide" do
    sign_in users(:admin)
    assert_difference('Clauseguide.count') do
      post :create, clauseguide: { clause_id: 1, plan_id: 1}, guidenote: { text: "<p>test text for update</p>"}
    end
    #redirect to index if saved
    assert_redirected_to clauseguides_path
  end


  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: @clauseguide
    assert_response :success
  end


  test "should update clauseguide content" do
    sign_in users(:admin)
      
    patch :update, id: @clauseguide, clauseguide: { clause_id: 1, plan_id: 1}, guidenote: { text: "<p>test text for update</p>"}

    #redirect to index if updated
    assert_redirected_to clauseguides_path
  end


  test "should destroy clauseguide" do
    sign_in users(:admin)
    assert_difference('Clauseguide.count', -1) do
      delete :destroy, id: @clauseguide
    end

    assert_redirected_to clauseguides_path
  end


#clone
 test "should lsit clauses" do
    sign_in users(:admin)

    get :clone, id: @clauseguide.clause_id, plan_id: @clauseguide.plan_id
    assert_response :success

    assert_not_nil assigns(:clone_subsections)
    assert_not_nil assigns(:clause_id)
    assert_not_nil assigns(:plan_id)
    assert_not_nil assigns(:clauseguide)

  end

#clone clause list
#test "should return clauses via js"
#get :clone_clause, id: 
#    assert_response :success
#assert_not_nil assigns(:clauses)
#end


#create_clone
#  test "should clone clauseguide to clauses" do
#    sign_in users(:admin)
#    post :create_clone, clauseguide: { clause_id: 1, plan_id: 1, guidenote_id: 1}

    #redirect to index if saved
#    assert_redirected_to clauseguides_path
#  end



#assign
#  test "should list assignable guidance" do
#    sign_in users(:admin)

#    get :assign, id: @clauseguide.clause_id, plan_id: @clauseguide.plan_id # test without value for search_text
#    get :assign, id: @clauseguide.clause_id, plan_id: @clauseguide.plan_id, search_text: "????"
#    assert_response :success

#    assert_not_nil assigns(:clauseguide_id)
#    assert_not_nil assigns(:plan_id)
#    assert_not_nil assigns(:search_term)
#    assert_not_nil assigns(:clauses)

#  end

#assign_guides
#  test "should assign guidenotes to clauses" do
#    sign_in users(:admin)
#    post :create_clone, clauseguide: { clause_id: [1,2,3], plan_id: 1, guidenote_id: 1}
#  end

end
