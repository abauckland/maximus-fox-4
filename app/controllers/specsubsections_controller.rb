class SpecsubsectionsController < ApplicationController
  before_filter :require_user
  before_action :set_project, only: [:show, :add_subsections, :delete_subsections]

  layout "projects"

  def manage
    authorise_project_action(@project.id, ["manage", "edit"])
      
    @templates = Project.project_templates(@project)
  
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)
   
    if params[:template_id].blank? == true    
      @template = Project.find(@project.parent_id)
    else
      @template = Project.find(params[:template_id])     
    end

    if @project.ref_system.caws?
      @project_subsections = Cawssubsection.project_subsections(@project)
      @template_subsections = Cawssubsection.template_subsections(@project, @template)
    else  
#      @project_subsections = Unisubsection.project_subsections(@project)    
#      @template_subsections = Unisubsection.template_subsections(@project, @template)
    end 

  end
  
  
  ##POST
  def add
    authorise_project_action(@project.id, ["manage", "edit"]) 

    if @project.ref_system.caws?    
      speclines_to_add = Specline.cawssubsection_speclines(params[:template_id], params[:template_sections])
    else
#      speclines_to_add = Specline.unisubsection_speclines(params[:template_id], params[:template_sections])
    end

    speclines_to_add.each do |line_to_add|
      new_specline = Specline.new(line_to_add.attributes.merge(:project_id => params[:id]))
      new_specline.save
      clause_change_record = 3
      record_new(new_specline, clause_change_record)
    end                   

     redirect_to manage_specsubsection_path(:id => @project.id, :template_id => @template.id)     
  end


  ##POST
  def delete
    authorise_project_action(@project.id, ["manage", "edit"]) 

    if @project.ref_system.caws?    
      speclines_to_delete = Specline.cawssubsection_speclines(params[:template_id], params[:template_sections])
    else
#      speclines_to_delete = Specline.unisubsection_speclines(params[:template_id], params[:template_sections])
    end
    
    clauses_to_delete = speclines_to_delete.collect{|i| i.clause_id}.uniq.sort

    speclines_to_delete.each do |line_to_delete|        
      if line_to_delete.clause_line != 0       
        specline = line_to_delete
        clause_change_record = 3
        record_delete(specline, clause_change_record)             
      end
    line_to_delete.destroy
    end

    revision = Revision.where('project_id = ?', @project.id).last
    previous_changes_to_clause = Alteration.where(:project_id => params[:id], :clause_id => clauses_to_delete, :revision_id => revision.id)
    if !previous_changes_to_clause.blank?
      previous_changes_to_clause.each do |previous_change|
      previous_change.clause_add_delete = 3
      previous_change.save
      end    
    end

     redirect_to manage_specsubsection_path(:id => @project.id, :template_id => @template.id)     
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end
end
