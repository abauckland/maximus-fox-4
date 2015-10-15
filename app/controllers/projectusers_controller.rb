class ProjectusersController < ApplicationController

  before_action :set_project_user, only: [:new, :edit]
  before_action :set_project, only: [:new, :edit]
  before_action :set_subsections, only: [:new, :edit]

  layout "projects"


  def show
    authorize :projectuser, :show?
    @project = Project.find(params[:id])
    @projectusers = Projectuser.includes(:user, :project).where(:project_id => params[:id]).order(:role)
  end

  def edit

#    @projectuser = Projectuser.find(params[:id])
    set_subsections(@project)
  end

  def update


    @projectuser.update(projectuser_params)

    respond_to do |format|
        format.html { redirect_to projectusers_path(:id => @projectuser.project_id) }
    end
  end

  def new
    @projectuser = Projectuser.new
    set_subsections(@project)
  end


  # POST /projects
  # POST /projects.json
  def create

#    project_id = params[:projectuser][:project_id]
#    subsection_ids = params[:projectuser][:subsection_ids]

#    authorise_project_manager(project_id)

    @projectuser = Projectuser.new(projectuser_params)

    if @projectuser.save

      respond_to do |format| 
        format.html { redirect_to projectusers_path(:id => @projectuser.project_id) }
      end
    end
  end


def destroy

    @projectuser.destroy

    respond_to do |format|
      format.html { redirect_to projectusers_path(:id => @projectuser.project_id) }
      format.json { head :ok }
    end
end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_user
      @projectuser = Projectuser.where(:project_id => params[:id], :user_id => current_user.id).first
    end

    def pundit_user
      @projectuser
    end

    def set_project
#      set_project_user
      @project = Project.find(@projectuser.project_id)
    end

    def set_subsections(project)
#TODO ref_system
#       table_name = @project.refsystem.subsection
       table_name = @project.ref_system.subsection_name
       model = table_name.classify.constantize
       @subsections = model.project_subsections(@project)
    end


    def projectuser_params
      params.require(:projectuser).permit(:project_id, :user_id, :role, :date_from, :date_to, :subsection_ids => [])
    end

end
