require 'test_helper'

class SpecsubsectionsControllerTest < ActionController::TestCase

  include Devise::TestHelpers

  setup do
    @project = projects(:CAWS)
    @project_rev = projects(:CAWS_rev)
    @project_template = projects(:CAWS_template)
  end

#authorization
  test "not authenticated should get redirect" do
    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response :redirect
  end

  test "if user role is read should get redirect" do
    sign_in users(:employee_2)

    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response 403
  end

#manage
  test "should show project and template sections" do
    sign_in users(:owner)

    get :manage, id: @project.id, template_id: @project.parent_id
    assert_response :success

    assert_not_nil assigns(:template)
    assert_not_nil assigns(:templates)
    assert_not_nil assigns(:project_subsections)
    assert_not_nil assigns(:template_subsections)
  end


#add_subsections
#TODO add D10 & E10 subsetion to project_template to copy into project
#  test "should add subsections" do
#    sign_in users(:owner)

#    assert_difference('Specline.count') do
#      post :add, id: @project.id, template_id: @project_template.id, template_sections: [1,2]
#    end

#    #redirect to index if saved
#    assert_redirected_to manage_specsubsection_path(id: @project.id, template_id: @project.parent_id)
#  end

#add subsections with revision tracking on
# => test 'should add alterations'
# => end



#delete_subsections
  test "should remove subsections" do
    sign_in users(:owner)

    assert_difference('Specline.count', -37) do
      post :delete, id: @project.id, project_sections: [1,2]
    end

#    #redirect to index if saved
    assert_redirected_to manage_specsubsection_path(id: @project.id)
  end

#delete subsections with revision tracking on
  test 'should add alterations' do
    sign_in users(:owner)

    assert_difference('Alteration.count', +2) do
      post :delete, id: @project_rev.id, project_sections: [2]
    end

#    #redirect to index if saved
    assert_redirected_to manage_specsubsection_path(id: @project_rev.id)
  end




end