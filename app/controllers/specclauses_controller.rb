class SpecclausesController < ApplicationController


  before_filter :authenticate  
  before_action :set_project, only: [:manage, :add_clauses, :delete_clauses]

  layout "projects"

  
  def manage

    if @project.CAWS?
      #all users except user assigned role 'read' can add and delete clauses from subsection   
      #only those projects that the current user is a 'projectuser' has access to the current subsection are available as a template
      @subsection = Cawssubsection.where(:id => params[:subsection_id]).first

      #projects where projectuser
      user_projects = Project.project_templates(@project, current_user).cawssubsections(@subsection).ids
      
      #projects where projectuser: but a subsectionuser, but not a subsectionuser of current subsection 
      subsectionuser_ids = Subsectionuser.joins(:projectuser, :subsection
                                      ).where('projectusers.user_id' => current_user.id
                                      ).where.not('subsections.cawssubsection_id' => @subsection.id
                                      ).ids      
      
      projects_no_access_subsection = Project.joins(:projectusers => :subsectionusers).where('subsectionusers.id' => subsectionuser_ids).ids

      #users also have access to standard (specright) templates 
      standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).ids
      
      template_ids = user_projects - projects_no_access_subsection + standard_templates

      @templates = Project.where(:id => template_ids).order("code")

      #uses default template set for project unless different template is selected from drop down list
      #if user does not have access to subsection in default template select first available template that does
      if params[:template_id].blank?
        if template_ids.include?(@project.parent_id)
          @template = Project.find(@project.parent_id)
        else
          @template = @templates.first 
        end
      else
        @template = Project.find(params[:template_id])
      end

   
      @current_project_clauses = Clause.joins(:clauseref => [:subsection], :speclines => [:project => :projectusers]
                                      ).where('projectusers.user_id' => current_user.id
                                      ).where('speclines.project_id' => @project.id
                                      ).where('subsections.cawssubsection_id' => @subsection.id
                                      ).group(:id
                                      ).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                                      )
  
      template_clauses = Clause.joins(:clauseref => [:subsection], :speclines => [:project => :projectusers]
                                        ).where('speclines.project_id' => @template.id
                                        ).where('subsections.cawssubsection_id' => @subsection.id                                        
                                        ).group(:id
                                        ).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                                        )

       template_clause_ids = template_clauses.ids - @current_project_clauses.ids
        
       @template_project_clauses = Clause.joins(:clauseref).where(:id => template_clause_ids).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause')

    else
###uniclass code to go here - same as above 
    end     
  end


  def add_clauses

    speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => params[:template_clauses]) 
    speclines_to_add.each do |line_to_add|
      @new_specline = Specline.create(line_to_add.attributes.merge(:id => nil, :project_id => @project.id))
      record_new(@new_specline, event_type)
    end                   

    redirect_to manage_specclause_path(:id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
  end


  def delete_clauses     
    #get speclines for all clauses that are in include list    
    specline_lines_to_deleted = Specline.where(:project_id => @project.id, :clause_id => params[:project_clauses])      
    specline_lines_to_deleted.each do |existing_specline_line|
      @specline = existing_specline_line
      record_delete(@specline, event_type)  
      existing_specline_line.destroy
    end
    
    clause_ids = Clause.where(:id => params[:project_clauses]).ids
    #if there are previous changes update change event record
    update_clause_change_records(@project, @revision, clause_ids, event_type)

    if @project.CAWS?
      #find if any clauses are in current subsection after changes
      get_valid_spline_ref = Specline.cawssubsection_speclines(@project.id, params[:subsection_id]).last
    else
###uniclass code to go here - same as above 
    end  
  
    #if no clauses in subsection redirect to subsection manager
    if get_valid_spline_ref.blank?
      redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])
    else
      redirect_to manage_specclause_path(:id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
    end 
  #end
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
      return 2
    end
end
