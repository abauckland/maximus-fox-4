class SpecsubsectionsController < ApplicationController

  before_action :set_project
  before_action :set_revision, only: [:add, :delete]

  include ProjectuserDetails
  include RefsystemSettings

  layout "projects"


  def manage
    authorize :specsubsection, :manage?

    set_templates(@project)
    @template = Project.find(params[:template_id])

    @project_subsections = @subsection_model.project_subsections(@project)
#TODO both named scopes are the same
    @template_subsections = @subsection_model.template_subsections(@template).where.not(:id => @project_subsections.ids)

  end


  def add
    authorize :specsubsection, :add?

    clause_ids = Clause.ref_subsection_clauses(params[:template_id], params[:template_sections], @subsection_name).collect{|i| i.id}.uniq.sort

    if @revision
      section_alteration = Alteration.match_clause(clause_ids, @project, @revision).where(:clause_add_delete => 3).first
      if !section_alteration.blank?

        clause_ids.each do |clause_id|

          speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => clause_id)

          clause_alteration = Alteration.match_clause(clause_id, @project, @revision).where(:clause_add_delete => 2).first
          if !clause_alteration.blank?
            #for each line
            speclines_to_add.each do |line|
              previous_delete_record = Alteration.match_line(line, @revision).where(:event => 'deleted')
              if !previous_delete_record.blank?
                previous_delete_record.destroy
              else
                @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
                record_new(@new_specline, 1)
              end
            end
            # find lines previous deleted but not in new clause
            #same as left over lines when added lines have been processed
            clause = Clause.find(clause_id)
            update_clause_alterations(clause, @project, @revision, 1)
          else
            speclines_to_add.each do |line|
              @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
              record_new(@new_specline, 2)
            end
            previous_alterations = Alteration.match_clause(clause_id, @project, @revision).where(:event => 'deleted')
            previous_alterations.each do |alteration|
              alteration.update(:clause_add_delete => 2)
            end
          end
        end
      else
        clause_ids.each do |clause_id|
          speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => clause_id)
          speclines_to_add.each do |line|
            @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
            record_new(@new_specline, 3)
          end
        end
      end
    else
      #do not record revisions
      clause_ids.each do |clause_id|
        speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => clause_id)
        speclines_to_add.each do |line|
          @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
        end
      end
    end
#TODO add confirmation notice
    redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])
  end


  def delete
    authorize :specsubsection, :delete?

    clauses = Clause.ref_subsection_clauses(@project.id, params[:project_sections], @subsection_name)
    clauses.each do |clause|
      speclines_to_delete = Specline.where(:project_id => @project.id, :clause_id => clause.id)

      if @revision
        speclines_to_delete.each do |specline|
          record_delete(specline, 3)
          specline.destroy
        end
        update_clause_alterations(clause, @project, @revision, 3)
      else
        speclines_to_delete.each do |specline|
          specline.destroy
        end
      end
    end
#TODO add confirmation notice
    redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_revision
      @revision = Revision.where(:project_id => @project.id).where.not(:rev => nil).order('created_at').last
    end

    def set_templates(project)
#TODO change ref system names
#TODO check that only lists projects that user is a proejct_user for
#      user_projects = Project.user_projects(current_user).ref_system(@project
#                            ).where.not(:id => project.id
#                            ).order("code")
      user_projects = Project.joins(:projectusers
                            ).where('projectusers.user_id' => current_user.id, :ref_system => project.ref_system
                            ).where.not(:id => project.id
                            ).order("code")
#TODO check ids of template projects
#TODO change ref system names
#      standard_templates = Project.ref_system(@project).where(:id => [1..10]).order("code")
      standard_templates = Project.where(:id => [1..10], :ref_system => project.ref_system).order("code")
      @templates = standard_templates + user_projects
    end

    def event_type
      #indicate type event that addition of the specline is associated with
      #1 => line added/deleted/changed
      #2 => clause added/deleted
      #3 => subsection added/deleted
      #information used in reporting changes to the document
      return 3
    end

end