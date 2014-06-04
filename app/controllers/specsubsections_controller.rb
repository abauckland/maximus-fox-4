class SpecsubsectionsController < ApplicationController
  before_filter :authenticate
  before_filter :authorise_project_manager_editor, only: [:manage, :add, :delete]  
  before_action :set_project, only: [:manage, :add, :delete]
  before_action :set_project_user, only: [:manage, :add, :delete]



  layout "projects"

  def manage      
    user_templates = Project.project_templates(@project, current_user)
    standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system)    
    @templates = user_templates + standard_templates
  
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)

##if user does not have access to default template?
#whet is template is not that same ref_system?  
    if params[:template_id].blank? == true    
      @template = @templates.first
    else
      @template = Project.find(params[:template_id])     
    end

    if @project.ref_system == "CAWS"

      #filtered by users role and subsectionusers for projectusers
      project_subsection = Subsectionuser.joins(:projectuser).where('projectusers.user_id' => current_user.id).first   
      if project_subsection
        @project_subsections = Cawssubsection.project_subsections(@project).filter_user(current_user)
        @template_subsections = Cawssubsection.template_subsections(@project, @template).filter_user(current_user)
      else
        @project_subsections = Cawssubsection.project_subsections(@project).filter_user(current_user)
        @template_subsections = Cawssubsection.template_subsections(@project, @template)
      end

    else  
#      @project_subsections = Unisubsection.project_subsections(@project)    
#      @template_subsections = Unisubsection.template_subsections(@project, @template)
    end 

  end
  
  
  ##POST
  def add
    authorise_project_action(@project.id, ["manage", "edit"]) 

    if @project.ref_system == "CAWS"   
      speclines_to_add = Specline.cawssubsection_speclines(params[:template_id], params[:template_sections])
    else
#      speclines_to_add = Specline.unisubsection_speclines(params[:template_id], params[:template_sections])
    end

    speclines_to_add.each do |line_to_add|
      new_specline = Specline.new(line_to_add.attributes.merge(:project_id => params[:id]))
      new_specline.save
      clause_change_record = 3
      record_new(@new_specline, @clause_change_record)
    end                   

     redirect_to manage_specsubsection_path(:id => @project.id, :template_id => @template.id)     
  end


  ##POST
  def delete
    authorise_project_action(@project.id, ["manage", "edit"]) 

    if @project.ref_system == "CAWS"   
      speclines_to_delete = Specline.cawssubsection_speclines(params[:template_id], params[:template_sections])
    else
#      speclines_to_delete = Specline.unisubsection_speclines(params[:template_id], params[:template_sections])
    end
    
    clauses_to_delete = speclines_to_delete.collect{|i| i.clause_id}.uniq.sort

    speclines_to_delete.each do |line_to_delete|        
      if line_to_delete.clause_line != 0       
        specline = line_to_delete
        clause_change_record = 3
        record_delete(@specline, @clause_change_record)             
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

    def set_project_user
      @project_user = Projectuser.where(:user_id => current_user.id, :project_id => params[:id]).first 
    end
    
    def authorise_project_manager_editor
      set_project_user    
      if @project_user.role == "manage" || "edit"
        return @project_user
      else        
        redirect_to log_out_path  
      end 
    end
    
end
