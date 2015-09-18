class SpecificationsController < ApplicationController
#  before_filter :authenticate
  before_action :set_project

  include ProjectuserDetails
  include RefsystemSettings

  layout "projects"

  def empty_project
    #if there are no projects associated with current user - show different help information
    @projects = Project.user_projects(current_user)
    if @projects.length == 1
      @not_used = true
    end
  end


  def show

    #if no contents redirect to manage_subsection page
    speclines = Specline.where(:project_id => @project.id).first
    if speclines.blank?
      redirect_to empty_project_specification_path(@project.id)
    else

      #establish project clauses, subsections & sections
#      if @project.CAWS?

        #list of all subsections that can be selected - for small screen
        #filtered by users role and subsectionusers for projectusers
        project_subsection = Subsectionuser.joins(:projectuser).where('projectusers.user_id' => current_user.id).first
        if project_subsection
          @project_subsections = Cawssubsection.project_user_subsections(@project).filter_user(current_user)
        else
          @project_subsections = Cawssubsection.project_subsections(@project)
        end

        #estabish current value for selected section and subsection menues
        if params[:subsection].blank?
            @selected_subsection = @project_subsections.first
        else
            @selected_subsection = Cawssubsection.find(params[:subsection])
        end

        #get list of clausetypes in selected subsection
        @clausetypes = Clausetype.joins(:clauserefs => [:subsection, :clauses => [:speclines]]
                                ).where('speclines.project_id' => @project, 'subsections.cawssubsection_id' => @selected_subsection.id
                                ).group(:id).order(:id)

        #get all speclines in selected subsection
        @selected_specline_lines = Specline.show_cawssubsection_speclines(@project.id, @selected_subsection.id, @clausetypes.first.id)
#      else    
  ###uniclass code to go here - same as above       
#      end 


      if params[:clausetype].blank?
        @current_clausetype = @clausetypes.first
      else
        @current_clausetype = Clausetype.where(:id => params[:clausetype]).first 
      end

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @project }
      end      
    end
  end


  def show_tab_content
    if @project.CAWS?
      if params[:subsection_id]
        current_subsection_id = params[:subsection_id]
      else
        current_subsection_id = Cawssubsection.project_subsections(@project).ids.first
      end

      @clausetype_id = params[:clausetype_id]

      #get all speclines in selected subsection
      @selected_specline_lines = Specline.show_cawssubsection_speclines(@project.id, current_subsection_id, params[:clausetype_id])
    else
###uniclass code to go here - same as above       
    end 

    respond_to do |format|
      format.js  { render :show_tab_content, :layout => false } 
    end    
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

end
