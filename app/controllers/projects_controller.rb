class ProjectsController < ApplicationController
  before_filter :require_user
  before_action :set_project, only: [:index, :show, :empty_project, :edit, :update]

  # GET /projects
  # GET /projects.json
  def index
    
    authorise_project_action(@project.id, "all")
    
    @projects = Project.user_projects    
    if @projects.length == 1
      check_speclines = Specline.where(:project_id => @project.id).first
      if check_speclines.blank?
        @not_used = true
      end
    end 
  
  end


  def show
    authorise_project_action(@project.id, "all")
          
  end

  def empty_project
    
    authorise_project_action(@project.id, "all")        
    
    projects = Project.user_projects
    if projects.length == 1
      @not_used = true
    end 

  end


  # GET /projects/new
  def new
    authorise_project_action(@project.id, "all")        
    @project = Project.new    
  end



  # POST /projects
  # POST /projects.json
  def create
    authorise_project_action(@project.id, "all")
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        set_current_revision = Revision.create(:project_id => @project.id, :user_id => current_user.id, :date => Date.today)
        set_project_user = Projectuser.create(:project_id => @project.id, :user_id => current_user.id, :role => "manager")
        #format.html { redirect_to(:controller => "projects", :action => "manage_subsections", :id => @project.id) }
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        @project = Project.user_projects.first 
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end



  # GET /projects/1/edit
  def edit
    authorise_project_action(@project.id, ["manage"])

    @projects = Project.user_projects
    @template = Project.project_template(@project)
    @templates = Project.project_templates(@project)
        
    project_status_array = ['Draft', 'Preliminary', 'Tender', 'Contract', 'As Built']
    current_status_index = project_status_array.index(@project.pluck(:project_status))
    project_status_array_last_index = project_status_array.length
#update in view to make sure select box works correctly
    @available_status_array = project_status_array[current_status_index..project_status_array_last_index]

  end
    

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorise_project_action(@project.id, ["manage"]) 
                
    @project.update(project_params)
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
         
    respond_to do |format|     
        format.html { redirect_to edit_project_path(@project)}   
        format.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:code, :title, :parent_id, :company_id, :project_status, :ref_system, :rev_method, :logo_path, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at)
    end
end
