class SpecclausesController < ApplicationController

  before_action :set_project
  before_action :set_template
  before_action :set_revision

  include ProjectuserDetails
  include RefsystemSettings
  #order important so that model name is set
  before_action :set_subsection, only: [:manage, :delete_clauses]

  layout "projects"


  def manage
    authorize :specclause, :manage?

      #list of projects where project user has subsections assigned to them other than current
#TODO check that this returns correct projects
      user_projects_no_access_ids = Project.joins(:projectusers => :subsectionusers
                                      ).where('projectusers.user_id' => current_user.id
                                      ).where(:ref_system => @project.ref_system
                                      ).where.not('subsectionusers.subsection_id' => @subsection.id
                                      ).ids

#TODO change ref system names
      user_projects = Project.joins(:projectusers).where('projectusers.user_id' => current_user.id, :ref_system => @project.ref_system
                                          ).where.not(:id => @project.id
                                          ).where.not(:id => user_projects_no_access_ids
                                          ).order("code")
#TODO check ids of template projects
#TODO change ref system names
      standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).order("code")
      @templates = standard_templates + user_projects

      @current_project_clauses = Clause.project_subsection(@project, params[:subsection_id], @subsection_name, current_user)
      @template_project_clauses = Clause.where.not(:id => @current_project_clauses.ids
                                       ).project_subsection(@template, params[:subsection_id], @subsection_name, current_user)

  end


  def add_clauses
    authorize :specclause, :add_clauses?

    clauses = Clause.where(:id => params[:template_clauses])
    clauses.each do |clause|

      speclines_to_add = Specline.where(:project_id => @template.id, :clause_id => clause.id) 

      if @revision
        #record revisions
        clause_alteration = Alteration.match_clause(clause.id, @project, @revision).where(:clause_add_delete => 2).first #2 => clause added/deleted
        if !clause_alteration.blank?
          #for each line
          speclines_to_add.each do |line|
            previous_delete_record = Alteration.match_line(line, @revision).where(:event => 'deleted')
            if !previous_delete_record.blank?
                previous_delete_record.destroy
            else
              @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
              record_new(@new_specline, 1) #1 => line added/deleted/changed
            end
          end
          # find lines previous deleted but not in new clause
          #same as left over lines when added lines have been processed
          update_clause_alterations(clause, @project, @revision, 1) #1 => line added/deleted/changed
        else
          speclines_to_add.each do |line|
            @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
            record_new(@new_specline, 2) #2 => clause added/deleted
          end
        end
      else
        #do not record revisions
        speclines_to_add.each do |line|
          @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
        end
      end
    end

    redirect_to manage_specclause_path(:id => @project.id, :template_id => @template.id, :subsection_id => params[:subsection_id])
  end


  def delete_clauses
    authorize :specclause, :delete_clauses? 

    clauses = Clause.where(:id => params[:project_clauses])
    clauses.each do |clause|

      speclines_to_delete = Specline.where(:project_id => @project.id, :clause_id => clause.id)

      if @revision
        speclines_to_delete.each do |specline|
          record_delete(specline, 2) #2 => clause added/deleted
          specline.destroy
        end
        update_clause_alterations(clause, @project, @revision, 2) #2 => clause added/deleted
      else
        speclines_to_delete.each do |specline|
          specline.destroy
        end
      end
    end

#TODO seporate into separate method
    #find if any clauses are in current subsection after changes
    get_valid_spline_ref = Specline.subsection_speclines(@project.id, params[:subsection_id], @subsection_name).last
    if get_valid_spline_ref.blank?
      #update all alteration records for section so event_type = 3
      previous_alterations = Alteration.joins(:clause => [:clauseref => :subsection]
                                      ).where(:event => 'deleted', :clause_add_delete => 2, :project_id => project.id, :revision_id => @revision.id
                                      ).where(:subsection => @susbection.id
                                      )
#TODO this needs to update all reocrds as per delete section - check this is correct
      previous_alterations.each do |alteration|
        alteration.update(:clause_add_delete => 3)
      end

      redirect_to manage_specsubsection_path(:id => @project.id, :template_id => @template.id)
    else
      redirect_to manage_specclause_path(:id => @project.id, :template_id => @template.id, :subsection_id => params[:subsection_id])
    end 
  #end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_template
      if params[:template_id].blank?
        @template = Project.find(@project.parent_id)
      else
        @template = Project.find(params[:template_id])
      end
    end

    def set_subsection
      @subsection = @subsection_model.find(params[:subsection_id])
    end

    def set_revision
      @revision = Revision.where(:project_id => @project.id).where.not(:rev => nil).order('created_at').last
    end

    def event_type
      #indicate type event that addition of the specline is associated with
      #1 => line added/deleted/changed
      #2 => clause added/deleted
      #3 => subsection added/deleted
      #information used in reporting changes to the document
      return 2
    end
end
