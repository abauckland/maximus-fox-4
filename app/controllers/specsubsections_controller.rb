class SpecsubsectionsController < ApplicationController


#  before_filter :authenticate
  before_filter :authorise_project_manager_editor, only: [:manage, :add, :delete]
  before_action :set_project, only: [:manage, :add, :delete]

  layout "projects"


  def manage
    #only users with role 'manage' and 'edit' have access to action    
    #only those projects that the current user is a 'projectuser' of are available as a template
    #users also have access to standard (specright) templates
    user_project_ids = Specline.joins(:project => :projectusers
                            ).where('projectusers.user_id' => current_user.id, 'projects.ref_system' => @project.ref_system
                            ).where.not('projects.id' => params[:id]
                            ).pluck(:project_id).uniq.sort
    user_projects = Project.where(:id => user_project_ids)
    standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).order("code")
    template_ids = user_projects + standard_templates

    @templates = Project.where(:id => template_ids).order("code")

    #uses default template set for project unless different template is selected from drop down list
    if params[:template_id].blank?
      @template = Project.find(@project.parent_id)
    else
      @template = Project.find(params[:template_id])
    end

    #both types of users are able to add and delete all subsections
    #no requiremens to filter by role
    if @project.CAWS?

        @project_subsections = Cawssubsection.project_subsections(@project)
        template_subsection_ids = Cawssubsection.template_subsections(@project, @template).ids
        #take subsections already in project away from list of subsections available in template
        #prevents attempted over writing of subsections already in project
        template_subsection_ids = template_subsection_ids - @project_subsections.ids
        
        @template_subsections = Cawssubsection.where(:id => template_subsection_ids)
    else

#        @project_subsections = Unisubsection.project_subsections(@project)
#        template_subsection_ids = Unisubsection.template_subsections(@project, @template).ids
#        #take subsections already in project away from list of subsections available in template
#        template_subsection_ids = template_subsection_ids - @project_subsections.ids

#        @template_subsections = Unisubsection.where(:id => template_subsection_ids)
    end 
  end
  
  
  ##POST
  def add
    #only users with role 'manage' and 'edit' have access to action
    #get hash of all speclines within selected subsections
#    if @project.CAWS?   
#      selected_speclines = Specline.cawssubsection_speclines(params[:template_id], params[:template_sections])
#    else
#       speclines_to_add = Specline.unisubsection_speclines(template_id, subsection_ids)
#    end

    if @project.CAWS? 
      clauses = Clause.cawssubsection_clauses(params[:template_id], params[:template_sections])
    else
      #clauses = Clause.unisubsection_clauses(@project.id, params[:project_sections])
    end

    clause_ids = clauses.collect{|i| i.id}.uniq.sort

    revision = Revision.where(:project_id => @project.id).where.not(:rev => nil).order('created_at').last
    if revision

      section_alteration = Alteration.where(:clause_add_delete => 3, :project_id => @project.id, :clause_id => clause_ids, :revision_id => revision.id).first

      if !section_alteration.blank?

    #get speclines
        clause_ids.each do |clause_id|
          #assign speclines
          speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => clause_id)


            #record revisions
            clause_alteration = Alteration.where(:clause_add_delete => 3, :project_id => @project.id, :clause_id => clause_id, :revision_id => revision.id).first
            if !clause_alteration.blank?
              #for each line
              speclines_to_add.each do |line|
                previous_delete_record = Alteration.match_line(line, revision).where(:event => 'deleted')
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
              update_clause_alterations(clause, @project, revision, 1)
            else
              speclines_to_add.each do |line|
                @new_specline = Specline.create(line.attributes.merge(:id => nil, :project_id => @project.id))
                record_new(@new_specline, 2)
              end
              previous_alterations = Alteration.where(:event => 'deleted', :project_id => @project.id, :clause_id => clause_id, :revision_id => revision.id)
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


#    #add each specline within each subsection to the project
#    selected_speclines.each do |line_to_add|
#      @new_specline = Specline.create(line_to_add.attributes.merge(:id => nil, :project_id => params[:id]))
#      #for each specline record change event
#      #does not record event when project status is 'draft'
#      record_new(@new_specline, event_type)
#    end

     #render manage page
     redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])     
  end


  def delete
    #only users with role 'manage' and 'edit' have access to action
    #get hash of all speclines within selected subsections
#    if @project.CAWS?   
#      selected_speclines = Specline.cawssubsection_speclines(@project.id, params[:project_sections])
#    else
#       speclines_to_add = Specline.unisubsection_speclines(template_id, subsection_ids)
#    end



    if @project.CAWS? 
      clauses = Clause.cawssubsection_clauses(@project.id, params[:project_sections])
    else
      #clauses = Clause.unisubsection_clauses(@project.id, params[:project_sections])
    end
  #get speclines
    clauses.each do |clause|
      #assign speclines
      speclines_to_delete = Specline.where(:project_id => @project.id, :clause_id => clause.id) 

      revision = Revision.where(:project_id => @project.id).where.not(:rev => nil).order('created_at').last
      if revision
        speclines_to_delete.each do |specline|
          record_delete(specline, 3)
          specline.destroy
        end
        update_clause_alterations(clause, @project, revision, 3)
      else
        speclines_to_delete.each do |specline|
          specline.destroy
        end
      end
    end

#    #destroy each specline within each subsection from the project
#    selected_speclines.each do |line|        
#      #for each specline record change event
#      #does not record event when project status is 'draft'
#      record_delete(line, event_type)
#      line.destroy
#    end

#    #get array of ids for clauses that are to be deleted from the project
#    clauses_to_delete = selected_speclines.collect{|i| i.clause_id}.uniq.sort

#    #if there are previous changes update change event record
#    update_clause_change_records(@project, @revision, clauses_to_delete, event_type)

    #render manage page
    redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def event_type
      #indicate type event that addition of the specline is associated with
      #1 => line added/deleted/changed
      #2 => clause added/deleted
      #3 => subsection added/deleted
      #information used in reporting changes to the document
      return 3
    end

    def authorise_project_manager_editor
      @project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id]).first
      if @project_user.manage? || @project_user.edit?
        return @project_user
      else
        redirect_to log_out_path
      end 
    end
    
end
