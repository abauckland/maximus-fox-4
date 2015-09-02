class ProjectsController < ApplicationController

  before_action :set_project, only: [:edit, :update]
  before_action :set_projects, only: [:index, :edit, :update]
  before_action :set_templates, only: [:edit, :update]
  before_action :set_templates, only: [:edit, :update]
  before_action :set_available_status_array, only: [:edit, :update]
  before_action :set_project_user, only: [:index, :edit]


  def index
# => only required where role is placed after project title
#    @project_roles = policy_scope(Project).each_with_object({ }){ |c, hsh| hsh[c.id] = '#{c.projectcode_and_title} +' '+#{c.projectusers.role}'}

# => only needed if auto creation of demo project is omitted
#    @check_has_content = Specline.where(:project_id => @projects.ids).first
  end


  def new
    @project = Project.new
#TODO @ref_systems
  end


  def create
    @project = Project.new(project_params)
    if @project.save
      set_associated_defaults(@project)
      redirect_to specification_path(@project), notice: 'Project was successfully created.'
    else
      render :new
    end
  end


  def edit
    authorize :project, :edit?
  end


  def update
    authorize :project, :update?

    if @project.update(project_params)
      set_revision_status(@project)
      redirect_to edit_project_path(@project), notice: 'Project details have been updated'
    else
      render :edit
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_projects
      @projects = Project.joins(:projectusers).where('projectusers.user_id' => current_user.id).order("code")
    end

    def set_template
      @template = Project.project_template(@project)
    end

    def set_project_user
      if params[:id]
        @project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id]).first
      else
        @project_user = Projectuser.where(:user_id => current_user.id, :project_id => @projects.first.id).first
      end
    end

    def pundit_user
      @project_user
    end

    def set_templates
#TODO change ref system names
      user_projects = Project.joins(:projectusers).where('projectusers.user_id' => current_user.id, :ref_system => @project.ref_system).order("code")
#TODO check ids of template projects
#TODO change ref system names
      standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).order("code")
      @templates = standard_templates + user_projects
    end

    def set_available_status_array
      project_status_array = ['Draft', 'Preliminary', 'Tender', 'Contract', 'As_Built']
      current_status_index = project_status_array.index(@project.project_status)
      project_status_array_last_index = project_status_array.length
  #update in view to make sure select box works correctly
      @available_status_array = project_status_array[current_status_index..project_status_array_last_index]
    end


    def set_associated_defaults(project)
      Revision.create(:project_id => project.id, :user_id => current_user.id, :date => Date.today)
      Printsetting.create(:project_id => project.id)

#TODO temp code - delete on full implementation of project user code
      new_project_users =  User.where(:company_id => current_user.company_id)
      new_project_users.each do |user|
        Projectuser.create(:project_id => project.id, :user_id => user.id, :role => "manage")
      end
#TODO Projectuser.create(:project_id => @project.id, :user_id => user.id, :role => "manage")
    end


    def set_revision_status(project)

      if project.project_status != 'Draft'
        #if status is not draft, check if revisions status has been changed to '-'
        revision = Revision.where(:project_id => project.id).first
        #if status has not been changed previously, change to '-' and record project status for revision
        if revision.rev.blank?
          revision.update(:project_status => project.project_status, :rev => '-')
        #else just update with current project status in last revision record
        else
          last_revision = Revision.where(:project_id => project.id).last
          last_revision.update(:project_status => project.project_status)
        end
      end
    end


    def project_params
      params.require(:project).permit(:client_name, :client_logo, :code, :title, :parent_id, :company_id, :project_status, :ref_system, :project_image)
#TODO params.require(:project).permit(:client_name, :client_logo, :code, :title, :parent_id, :company_id, :project_status, :refsystem_id, :project_image)
    end

end