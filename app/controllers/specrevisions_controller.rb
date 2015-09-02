class SpecrevisionsController < ApplicationController

  before_action :set_project
  before_action :set_revision

  include ProjectuserDetails
  include RefsystemSettings

  layout "projects"


  def show
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)

    #check if status of the project has changed since last revision    
    check_project_status_change(@project, @revision)

    @revisions = Revision.where(:project_id => params[:id]).order('created_at')


#list of tabs that can be seen should depend on the scope of the user

    #get list of susbections that can be access by user
    #governed by the level of access given to them in subsectionusers table
    #if user not list against any subsections they will be able to see all subsection in project
    authorised_subsection_ids(@project)

    #tab menu - estabished list of subsections with revisions
    #filtered by users role and subsectionusers for projectusers
    project_subsection = Subsectionuser.joins(:projectuser).where('projectusers.user_id' => current_user.id).first
    if project_subsection
      @subsections = @subsection_model.all_subsection_revisions(@project, @revision).filter_user(current_user)
    else
      @subsections = @subsection_model.all_subsection_revisions(@project, @revision)
    end

    @subsection = @subsections.first

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @revision }
    end
  end


  def show_rev_tab_content

    @subsection = @subsection_model.find(params[:subsection_id])

    respond_to do |format|
      format.js  { render :show_rev_tab_content, :layout => false }
    end
  end


  private

    def set_project
      @project = Project.find(params[:id])
    end

    def set_revision
      if params[:revision_id].blank?
        @revision = Revision.where(:project_id => params[:id]).order('created_at').last
      else
        @revision = Revision.find(params[:revision_id])
      end
    end

    def authorised_subsection_ids(project)
      permitted_subsections = Subsectionuser.joins(:projectuser).where('projectusers.user_id' => current_user.id, 'projectusers.project_id' => project.id)
      if permitted_subsections.blank?
        @authorised_subsection_ids = Subsection.joins(:clauseref => [:clause => :specline]
                                       ).where('speclines.project_id' =>project.id
                                       ).group(:id)
      else
        @authorised_subsection_ids = Subsection.joins(:subsectionusers => :projectusers
                                       ).where('projectusers.user_id' => @current_user.id, 'projectusers.project_id' => project.id
                                       ).group('subsectionusers.subsection_id')
      end
    end

end