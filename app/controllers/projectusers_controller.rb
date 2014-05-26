class ProjectusersController < ApplicationController
  before_filter :authenticate
  before_filter :authorise_project_manager, only: [:index]
  before_action :set_project, only: [:index]

  # GET /projects
  # GET /projects.json
  def index
  #authenticate that there is a logged in user
  #only user with project manager role can access view
  
    @projectusers = Projectuser.include(:users, :projects).where(:project_id => params[:id]).order('projectusers.role, users.name')    

    @projectuser = Projectuser.new 
    
    if @project.ref_system == "caws"
       @subsections = Cawssubsections.joins(:subsection => [:clauserefs => [:clauses => :speclines]]
                                    ).where('speclines.projects_id' => @project.id
                                    )
    else
#uniclass query here      
    end    
  end


  # POST /projects
  # POST /projects.json
  def create
        
    #hash of paramtere  
    projectuser_params
    
    project_id = projectuser_params[:project_id]
    email = projectuser_params[:email]
    role = projectuser_params[:role]
    subsections = projectuser_params[:subsections]
    
    #allow only manager of project to create new project users
    project_user = Projectuser.where(:user_id => current_user.id, :project_id => project_id , :role => "manage").first    
    if project_user.blank?
      redirect_to log_out_path
    end 
    
    user = User.where(:email => :email).first

    @projectuser = Projectuser.new(:project_id => project_id, :user_id => user.id, :role => role)
    
    #save project users - without subsectionuser recored for project user, user is able to access the whole project
    if @projectuser.save
      if subsections
        if @project.ref_system == "caws"
        
          subsections.each do |subsection|
            subsection_ref = Subsection.where(:cawssubsection_id => subsection).first
            @subsection = Subsectionuser.create(:subsection => subsection_ref.id, :projectuser => @projectuser.id)
          end
        else
#uniclass query here    
        end 
      end     
      
      respond_to do |format| 
        format.html { render :action => "index"}
        format.xml  { render :xml => @projectuser.errors, :status => :unprocessable_entity }
      end 
    end 
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projectuser_params
      params.require(:projectuser).permit(:project_id, :email, :role, :subsections)
    end
    
    def authorise_project_manager
      project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id], :role => "manage").first    
      if project_user.blank?
        redirect_to log_out_path
      end 
    end

end
