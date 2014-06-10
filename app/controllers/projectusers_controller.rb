class ProjectusersController < ApplicationController
  before_filter :authenticate
  before_action :set_project, only: [:index]
  before_action :set_project_user, only: [:edit, :destroy]


  layout "projects"

  # GET /projects
  # GET /projects.json
  def index

    authorise_project_manager(params[:id])
    
    @projectusers = Projectuser.includes(:user, :project).where(:project_id => params[:id]).order('projectusers.role')
    
    user_ids = @projectusers.collect{|i| i.user_id}.uniq.sort   
    @company_users = User.where(:company_id => current_user.company_id).where.not(:id => user_ids)
    
    @projectuser = Projectuser.new 
    
    if @project.ref_system == "CAWS"
       @subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                    ).where('speclines.project_id' => @project.id
                                    )
    else
#uniclass query here      
    end    
  end


  def edit

    authorise_project_manager(@projectuser.project_id)   
        
    if @projectuser.project.ref_system == "CAWS"
       @subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                    ).where('speclines.project_id' => @projectuser.project_id
                                    )
    else
#uniclass query here      
    end  
  end

  def update
    @projectuser= Projectuser.find(params[:id])
    @projectuser.update(projectuser_params)

    respond_to do |format|     
        format.html { redirect_to  :action => "index", :id => @projectuser.project_id }   
    end
  end

  # POST /projects
  # POST /projects.json
  def create
        
    
    project_id = params[:projectuser][:project_id]
    subsection_ids = params[:projectuser][:subsection_ids]
    
    authorise_project_manager(project_id)

    @projectuser = Projectuser.new(projectuser_params)
    
    #save project users - without subsectionuser recored for project user, user is able to access the whole project
    if @projectuser.save
      if subsection_ids
        if @projectuser.project.ref_system == "CAWS"
        
          subsection_ids.each do |subsection_id|
            subsection_ref = Subsection.where(:cawssubsection_id => subsection_id).first
            if subsection_ref
              @subsection = Subsectionuser.create(:subsection => subsection_ref.id, :projectuser => @projectuser.id)
            end
          end
        else
#uniclass query here    
        end 
      end     
      
    @project = Project.where(:id => @projectuser.project_id).first  
      
      respond_to do |format| 
        format.html { redirect_to  :action => "index", :id => @projectuser.project_id }
      end 
    end 
  end

def destroy

    @subsectionusers = Subsectionuser.where(:projectuser_id => @projectuser.id)
    @subsectionusers.each do |subsectionuser|
      subsectionuser.destory
    end
    
    @projectuser.destroy

    respond_to do |format|
      format.html { redirect_to :action => "index", :id => @projectuser.project_id }
      format.json { head :ok }
    end  
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_project_user
      @projectuser = Projectuser.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def projectuser_params
      params.require(:projectuser).permit(:project_id, :user_id, :role, :subsection_ids)
    end
        
    def authorise_project_manager(project_id)
      #allow only manager of project to create new project users
      project_user = Projectuser.where(:user_id => current_user.id, :project_id => project_id , :role => "manage").first    
      if project_user.blank?
        redirect_to log_out_path
      end       
    end

end
