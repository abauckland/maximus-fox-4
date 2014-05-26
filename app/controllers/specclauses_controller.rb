class SpecclausesController < ApplicationController
  before_action :set_project, only: [:show, :add_clauses, :delete_clauses]

  layout "projects"


def show
  authorize @project 

  #call to protected method that establishes text to be shown for project revision status
  current_revision_render(@project)

  if params[:template_id].blank? == true    
    @template = Project.where(:id => @project.parent_id).first
  else
    @template = Project.where(:id => params[:template_id]).first     
  end

  if @project.ref_system.caws?
    
    @subsection = Cawssubsection.where(:id => params[:subsection_id]).first
 
    @selectable_templates = Project.cawssubsection_project_templates(@project, @subsection)
  
    @current_project_clauses = Clause.joins(:clauseref => [:subsections], :speclines => [:projects => :projectusers]
                              ).where('projectusers.user_id' => current_user.id
                              ).where('speclines.project_id' => @project.id
                              ).where('subsections.cawssubsection_id' => subsection.id
                              ).group(:id
                              ).order('clauserefs.clausetype_id, clauserefs.clause, clauserefs.subclause'
                              )
  
    @template_project_clauses = Clause.joins(:clauseref, :speclines
                              ).where('projectusers.user_id' => current_user.id
                              ).where('speclines.project_id' => @template.id
                              ).where('subsections.cawssubsection_id' => subsection.id
                              ).where.not('speclines.project_id' => @project.id
                              ).group(:id
                              ).order('clauserefs.clausetype_id, clauserefs.clause, clauserefs.subclause'
                              )
  else
###uniclass code to go here - same as above 
  end     
end


def add_clauses
  authorize @project   

    speclines_to_add = Specline.where(:project_id => params[:template_id], :clause_id => params[:template_clauses]) 
    speclines_to_add.each do |line_to_add|
      @new_specline = Specline.new(line_to_add.attributes.merge(:project_id => @project.id))
      @new_specline.save
      @clause_change_record = 2
      record_new(@specline, @clause_change_record)
    end                   

    redirect_to manage_speclause_path(:id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
    #redirect_to(:controller => "speclauses", :action => "manage", :id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
 
  #end
end


def delete_clauses
  authorize @project     
     
    #get all clauses that are in include list    
    specline_lines_to_deleted = Specline.where(:project_id => @project.id, :clause_id => params[:project_clauses])      
    specline_lines_to_deleted.each do |existing_specline_line|
      @specline = existing_specline_line
      @clause_change_record = 2
      record_delete(@specline, @clause_change_record)  
      existing_specline_line.destroy
    end
      
    @revision = Revision.where('project_id = ?', @project.id).last

    previous_changes_to_clause = Alteration.where(:project_id => @project.id, :clause_id => params[:project_clauses], :revision_id => @revision.id)
    if !previous_changes_to_clause.blank?
      previous_changes_to_clause.each do |previous_change|
        previous_change.clause_add_delete = 2
        previous_change.save
      end    
    end

  if @project.ref_system.caws?
    #find if any clauses are in current subsection after changes
    get_valid_spline_ref = Specline.cawssubsection_specline(@project.id, params[:subsection_id]).last
  else
###uniclass code to go here - same as above 
  end  
  
    #if no clauses in subsection redirect to subsection manager
    if get_valid_spline_ref.blank?
      redirect_to manage_specsubsection_path(:id => @project.id, :template_id => params[:template_id])
      #redirect_to(:controller => "specsubsections", :action => "manage", :id => @project.id, :template_id => params[:template_id])
    else
      redirect_to manage_speclause_path(:id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
      #redirect_to(:controller => "speclauses", :action => "manage", :id => @project.id, :template_id => params[:template_id], :subsection_id => params[:subsection_id])
    end 
  #end
end
######################################



  private
    # Use callbacks to share common setup or constraints between actions.    
    def set_project
      @project = Project.find(params[:id])
    end


end
