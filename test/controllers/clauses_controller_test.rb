require 'test_helper'

class ClausesControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
    @project_rev = projects(:CAWS_rev)
    @revision = revisions(:CAWS_nil)
    @clause = clauses(:CAWS_A10_1110_title_1)
    @cawssubsection = cawssubsections(:A10)
    @subsection = subsections(:CAWS_A10)
  end

#authorization
  test "not authenticated should get redirect" do
    get :new, id: @project.id, subsection_id: @cawssubsection.id
    assert_response :redirect
  end

#!!! not authoirsation set up in controller action
  test "if user role is read should get redirect" do
    sign_in users(:employee_2)
    get :new, id: @project.id, subsection_id: @cawssubsection.id
    assert_response 403
  end

  test "if user role is read should not create clause" do
    sign_in users(:employee_2)
    post :create, id: @project.id, clause: { id: @project.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "5120" }}, clause_content: "blank_content"
    assert_response 403
  end


#new
  test "should show form" do
    sign_in users(:owner)

    get :new, id: @project.id, subsection_id: @cawssubsection.id
    assert_response :success
  end 


#create
  test "should create clause" do
    sign_in users(:owner)

    assert_difference('Specline.count', +2) do
      post :create, id: @project.id, clause: { id: @project.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "5120" }}, clause_content: "blank_content"
    end

    assert_not_nil assigns(:new_specline)
    assert_not_nil assigns(:clause)

    #redirect to index if saved
    assert_redirected_to manage_specclause_path(id: @project.id, subsection_id: @subsection.id)
  end

  test "should create clause and record alteration" do
    sign_in users(:owner)

    assert_difference('Alteration.count', +2) do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "5120" }}, clause_content: "blank_content"
    end

#   #redirect to index if saved
    assert_redirected_to manage_specclause_path(id: @project_rev.id, subsection_id: @subsection.id)
  end



  test "should show error where no title" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "", clauseref_attributes: { subsection_id: 1, full_clause_ref: "5120" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end

  test "should show error where no code" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end

  test "should show error where code wrong length" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "125" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end

  test "should show error where code begins with 0" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "0125" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end

  test "should show error where duplicate clause code in section" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "test title", clauseref_attributes: { subsection_id: 1, full_clause_ref: "1110" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end

  test "should show error where duplicate clause in project" do
    sign_in users(:owner)

    assert_no_difference('Specline.count') do
      post :create, id: @project_rev.id, clause: { id: @project_rev.id, project_id: 1, title_text: "title_1", clauseref_attributes: { subsection_id: 1, full_clause_ref: "1110" }}, clause_content: "blank_content"
    end

#    assert_redirected_to new_clause_path(id: @project.id, subsection: @subsection.id)
#    assert_equal [": Clause title cannot be blank"], clause.errors.messages[:title_text]
  end



#new_clone_project_list
  test "should list projects" do
    sign_in users(:owner)

    xhr :get, :new_clone_project_list, format: :js, id: @project.id
    assert_response :success

    assert_not_nil assigns(:projects)
  end


#new_clone_subsection_list
  test "should list subsections" do
    sign_in users(:owner)

    xhr :get, :new_clone_subsection_list, format: :js, id: @project.id
    assert_response :success

    assert_not_nil assigns(:clone_subsections)
  end


#new_clone_clause_list
  test "should list clauses" do
    sign_in users(:owner)

    xhr :get, :new_clone_clause_list, format: :js, id: @project.id, subsection: @cawssubsection.id
    assert_response :success

    assert_not_nil assigns(:clone_clauses)
  end



  test "should create clone of clause" do
    sign_in users(:owner)

    assert_difference('Specline.count', +7) do
      post :create, id: @project.id,
                    clause: { id: @project.id, project_id: 1, title_text: "test title",
                    clauseref_attributes: { subsection_id: 1, full_clause_ref: "5120" }},
                    clause_content: "clone_content",
                    clone_template_id: "1",
                    clone_section_id: "1",
                    clone_clause_id: "11"
    end

    assert_not_nil assigns(:new_specline)
    assert_not_nil assigns(:clause)

    #redirect to index if saved
    assert_redirected_to manage_specclause_path(id: @project.id, subsection_id: @subsection.id)
  end


end
