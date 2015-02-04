class ProjectsController < ApplicationController
#  before_filter :authenticate

  before_filter :authorise_project_manager, only: [:update]
  before_action :set_project, only: [:empty_project, :show, :edit, :update]
  before_action :set_projects, only: [:edit, :update]
  before_action :set_templates, only: [:edit, :update]
  before_action :set_templates, only: [:edit, :update]
  before_action :set_available_status_array, only: [:edit, :update]
  before_action :set_project_user, only: [:show, :edit]
#  before_action :set_project_user, only: [:index]

  # GET /projects
  # GET /projects.json
  def index
  #authenticate that there is a logged in user
  #user is only shown projects they have access to   

    #list projects user is assigned to
#changes this to create hash of projects with user access in brackets
    @projects = Project.user_projects_access(current_user)
   # @project = @projects.first  
    @project_user = Projectuser.where(:user_id => current_user.id, :project_id => @projects.first.id).first

    #if user is not assigned to any project
    #show intro page and option to create a project
    #render partial 1

    #if user is assigned to projects
      #if only one project which does not have content - intro page and option to create a project
      if @projects
        @check_has_content = Specline.where(:project_id => @projects.first.id).first
      end 
      #render partial 1 
    
      #if more than one project or single project has content
      #render partion 2      
  end

  def show
    @projects = Project.user_projects(current_user)
  end



  # GET /projects/new
  def new
    @project = Project.new
  end



  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)


      if @project.save
        Revision.create(:project_id => @project.id, :user_id => current_user.id, :date => Date.today)
        Printsetting.create(:project_id => @project.id)

        new_project_users =  User.where(:company_id => current_user.company_id)
        new_project_users.each do |user|
          Projectuser.create(:project_id => @project.id, :user_id => user.id, :role => "manage")
        end

        redirect_to specification_path(@project), notice: 'Project was successfully created.'
      else
        render :new
      end
  end



  # GET /projects/1/edit
  def edit

    @project_user = Projectuser.where(:user_id => current_user.id, :project_id => @project.id).first
    #if project user does not have permission to edit project redirect to project/show
    if !@project_user.manage?
      redirect_to project_path(@project.id)
    end

  end


  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update

    if @project.update(project_params)
    #after new project status set, check if status is 'draft' 
      if @project.project_status != 'Draft'
        #if status is not draft, check if revisions status has been changed to '-'
        revision = Revision.where('project_id = ?', @project.id).first
        #if status has not been changed previously, change to '-' and record project status for revision
        if revision.rev.blank?
          revision.update(:project_status => @project.project_status, :rev => '-')
        #else just update with current project status in last revision record
        else
          last_revision = Revision.where('project_id = ?', @project.id).last
          last_revision.update(:project_status => @project.project_status)
        end
      end
      redirect_to edit_project_path(@project)
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
      @projects = Project.user_projects(current_user)
    end

    def set_template
      @template = Project.project_template(@project)
    end

    def set_templates
      user_project_ids = Specline.joins(:project => :projectusers
                              ).where('projectusers.user_id' => current_user.id, 'projects.ref_system' => @project.ref_system
                              ).where.not('projects.id' => params[:id]
                              ).pluck(:project_id).uniq.sort
      user_projects = Project.where(:id => user_project_ids)
      standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).order("code")
      template_ids = user_projects + standard_templates
  
      @templates = user_projects + standard_templates
    end

    def set_available_status_array
      project_status_array = ['Draft', 'Preliminary', 'Tender', 'Contract', 'As_Built']
      current_status_index = project_status_array.index(@project.project_status)
      project_status_array_last_index = project_status_array.length
  #update in view to make sure select box works correctly
      @available_status_array = project_status_array[current_status_index..project_status_array_last_index]
    end

    def set_project_user
      @project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id]).first 
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:client_name, :client_logo, :code, :title, :parent_id, :company_id, :project_status, :ref_system, :project_image)
    end

    def authorise_project_manager
      set_project_user
      if @project_user.manage?
        return @project_user
      else
        redirect_to log_out_path  
      end 
    end

end
