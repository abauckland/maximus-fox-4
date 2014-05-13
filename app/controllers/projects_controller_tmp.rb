class ProjectsController < ApplicationController
  before_action :set_project, only: [:edit, :update]

  # GET /projects
  # GET /projects.json
  def index
    
    #@projects = Project.where("company_id =?", current_user.company_id).order("code")     
    
    #get projects for accesible by current user
    #scope defined in project_policy.rb
    @projects = Project.user_projects
    authorize @projects    
    
#move to view @projects.first.???    
    #@current_project = @projects.first

#move to view
    #@tutorials = Help.all 

   
    #if @projects.length == 1
    #  check_speclines = Specline.where(:project_id => @projects.first.id).first
    #  if check_speclines.blank?
    #    @not_used = true
    #  end
    #end
    
    #check if project has any contents
    #sets which partial is rendered in the index view
    if Specline.where(:project_id => @projects.first.id).first
      @not_used = true
    end 
  
  end

  # GET /projects/1
  # GET /projects/1.json
#  def show
#    authorize @project 
    
#    @projects = Project.where('company_id =?', current_user.company_id).order("code") 
  
#    @current_project_template = Project.select('code, title').where('id = ?', @current_project.parent_id).first
    
    #call to protected method that restablishes text to be shown for project revision status
#    current_revision_render(@current_project)

    #establish project clauses, subsections & sections    
 ##   @project_subsections = Subsection.select('subsections.id, subsections.section_id, subsections.ref, subsections.text'
#                                    ).joins(:clauserefs =>  [:clauses => :speclines]
#                                    ).where('speclines.project_id' => @current_project.id
#                                    ).uniq.sort  

    #if no contents redirect to manage_subsection page
#    if @project_subsections.blank?
#      redirect_to empty_project_project_path(@current_project.id)
#    else

#      #array_project_subsection_ids = @project_subsections.collect{|i| i.id}
#      array_project_subsection_ids = @project_subsections.ids      
#      #array_project_section_ids = @project_subsections.collect{|i| i.section_id}.uniq.sort      
#      array_project_section_ids = @project_subsections.pluck(:section_id).uniq.sort 
      
#      @project_sections = Section.where(:id => array_project_section_ids)
      #check for other variables that are needed below

  
      #estabish list and current value for section and subsection select menues
#      if params[:section].blank?
#        if params[:subsection].blank?     
#            @selected_key_section = @project_sections.first
#            @selected_key_subsection = Subsection.select('id, guidepdf_id'
#                                                ).where(:id => array_project_subsection_ids, :section_id => @selected_key_section.id
#                                                ).first    
#       else         
#            @selected_key_subsection = Subsection.find(params[:subsection])
#            @selected_key_section = Section.select('id').where(:id => @selected_key_subsection.section_id).first

#       end
#      else
#            @selected_key_section = Section.select('id').where(:id => params[:section]).first
#            @selected_key_subsection = Subsection.where(:id => array_project_subsection_ids, :section_id => @selected_key_section.id).first      
#      end
#      @selected_subsections = Subsection.where(:id => array_project_subsection_ids, :section_id => @selected_key_section.id)


#      @clausetypes = Clausetype.joins(:clauserefs => [:clauses => :speclines]
#                              ).where('speclines.project_id' => @current_project, 'clauserefs.subsection_id' => @selected_key_subsection.id
#                              ).uniq.sort 
    
#      @selected_specline_lines = Specline.includes(:txt1, :txt3, :txt4, :txt5, :txt6, :identity_id, :perform_id, :clause => [ :clausetitle, :guidenote, :clauseref => [:subsection]]
#                                        ).where(:project_id => @current_project.id, 'clauserefs.subsection_id' => @selected_key_subsection.id, 'clauserefs.clausetype_id' => @clausetypes.first.id
#                                        ).order('clauserefs.clausetype_id, clauserefs.clause, clauserefs.subclause, clause_line')                           
    
#      if params[:clausetype].blank?
#        @current_clausetype = @clausetypes.first 
#      else
#        @current_clausetype = Clausetype.where(:id => params[:clausetype]).first 
#      end
    
#      respond_to do |format|
#        format.html # show.html.erb
#        format.xml  { render :xml => @project }
 #     end      
#    end
#  end


#  def show_tab_content
#    current_project_id = params[:id]
#    if params[:subsection_id]
#      current_subsection_id = params[:subsection_id]
#    else
#      first_project_subsection = Subsection.select('subsections.id, subsections.section_id, subsections.ref, subsections.text'
#                                          ).joins(:clauserefs =>  [:clauses => :speclines]
#                                          ).where('speclines.project_id' => current_project_id
#                                          ).first
#                                           
#      current_subsection_id = first_project_subsection.id      
#    end
#    @clausetype_id = params[:clausetype_id]
#    @selected_specline_lines = Specline.includes(:txt1, :txt3, :txt4, :txt5, :txt6, :identity_id, :perform_id, :clause => [:clausetitle, :guidenote, :clauseref => [:subsection]]
#                                      ).where(:project_id => current_project_id, 'clauserefs.subsection_id' => current_subsection_id, 'clauserefs.clausetype_id' => @clausetype_id
#                                      ).order('clauserefs.clause, clauserefs.subclause, clause_line')                           
#
#    respond_to do |format|
#      format.js  { render :show_tab_content, :layout => false } 
#    end    
#  end


  def empty_project         
    @projects = policy_scope(Project).order("code")  
    authorize @projects

#move to view            
      #if @projects.length == 1
      #  @not_used = true
      #end
  end



  # GET /projects/new
  def new
    @project = Project.new
    authorize @project 
   
    @projects = Project.user_projects(current_user)   
    @templates = Project.project_templates(@project)
    
  end



  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    authorize @project 

#move to view
    #@project.company_id = current_user.company_id
    
    #@projects = Project.where(:company_id => current_user.company_id).order("code")
    #user_projects = scope in project.rb
#what is this required for
   @projects = Project.user_projects(current_user).order("code")    
    
    respond_to do |format|
      if @project.save
         set_current_revision = Revision.create(:project_id => @project.id, :user_id => current_user.id, :date => Date.today)
         set_project_user = Projectuser.create(:project_id => @project.id, :user_id => current_user.id, :role => "manager")
        #format.html { redirect_to(:controller => "projects", :action => "manage_subsections", :id => @project.id) }
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
      
      #@current_project = Project.where("company_id =?", current_user.company_id).order("code").first
      @project = Project.user_projects(current_user).order("code").first 
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /projects/1/edit
  def edit
    authorize @project 
    
    #@projects = Project.where("company_id =?", current_user.company_id).order("code")
    #user_projects = scope in project.rb
    @projects = Project.user_projects(current_user).order("code")
    
    #project_templates = Project.where("id != ? AND company_id =?", @current_project.id, current_user.company_id).order("code")

    #allow main account view projects within admin account (company_id = 2)
    current_project_and_templates(@project.id, current_user.company_id)
        
    #get curent template for project
    #@current_project_template = Project.find(@current_project.parent_id)  
#not needed in view  - can this be id only - @project.parent_id
#    @current_project_template = Project.find(@project.parent_id)
    
    #@project = @current_project    
    #project_status_array = [['Draft', 'Draft'],['Preliminary', 'Preliminary'], ['Tender', 'Tender'], ['Contract', 'Contract'], ['As Built', 'As Built']]
    #current_status = @current_project.project_status
    #current_status_index = project_status_array.index([current_status, current_status])
    #project_status_array_last_index = project_status_array.length
    #@available_status_array = project_status_array[current_status_index..project_status_array_last_index]

    project_status_array = ['Draft', 'Preliminary', 'Tender', 'Contract', 'As Built']
    current_status_index = project_status_array.index(@project.pluck(:project_status))
    project_status_array_last_index = project_status_array.length
#update in view to make sure select box works correctly
    @available_status_array = project_status_array[current_status_index..project_status_array_last_index]

#is this needed?    
    #call to protected method that restablishes text to be shown for project revision status
    #current_revision_render(@current_project)

  end
    

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    authorize @project 
    #@project = Project.find(params[:id])
                
    @project.update(project_params)
    #after new project status set, check if status is 'draft' 
    if @project.project_status != 'Draft'
      #if status is not draft, check if revisions status has been changed to '-'
      check_rev_exists = Revision.where('project_id = ?', @project.id).first
      #if status has not been changed previously, change to '-' and record project status for revision
      if check_rev_exists.rev.blank?
        check_rev_exists.rev = '-'
        check_rev_exists.project_status = @project.project_status
        check_rev_exists.save
      #else just update with current project status in last revision record
      else
        current_project_rev = Revision.where('project_id = ?', @project.id).last
        current_project_rev.project_status = @project.project_status
        current_project_rev.save
      end
    end
         
    respond_to do |format|     
        format.html { redirect_to edit_project_path(@project)}   
        format.json { render json: @project.errors, status: :unprocessable_entity }
    end
  end


  # DELETE /projects/1
  # DELETE /projects/1.json
  #def destroy
  #  @project.destroy
  #  respond_to do |format|
  #    format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
  #    format.json { head :no_content }
  #  end
  #end

  # GET /projects/1/subsections
  # GET /projects/1/subsections.xml
#  def manage_subsections
    
#    @projects = Project.user_projects(current_user).order("code")

    #allow main account view projects within admin account (company_id = 2)
#    current_project_and_templates(@project.id, current_user.company_id)
  
    #call to protected method that restablishes text to be shown for project revision status
#    current_revision_render(@project)
   
#     if params[:selected_template_id].blank? == true    
#        @project_template = Project.find(@project.parent_id)
#     else
#        @project_template = Project.find(params[:selected_template_id])     
#     end

   # clause_line_array = Clauseref.joins(:clauses => :speclines).where('speclines.project_id' => @current_project.id).collect{|item2| item2.subsection_id}.sort.uniq 
#    clause_line_array = Subsection.joins(:clauserefs => [:clauses => :speclines]
#                                  ).where('speclines.project_id' => @project.id
#                                  ).pluck(:id).sort
   # template_clause_line_array = Clauseref.joins(:clauses => :speclines).where('speclines.project_id' => @current_project_template.id).collect{|item2| item2.subsection_id}.sort 
#    template_clause_line_array = Subsection.joins(:clauserefs => [:clauses => :speclines]
#                                            ).where('speclines.project_id' => @project_template.id
#                                            ).pluck(:id).sort
     
    #clause_line_array = current_project_clauses.collect{|item2| item2.subsection_id}.sort       
#    @current_project_subsections = Subsection.where(:id => clause_line_array)
  
#    unused_clause_line_array = template_clause_line_array - clause_line_array
#    @template_project_subsections = Subsection.where(:id => unused_clause_line_array)
    
    #if clause_line_array.blank?
   #   redirect_to empty_project_project_path(@current_project.id)
    #end
    
#  end
  
  
  ##POST
#  def add_subsections
#    authorize @project 
    #@current_project = Project.where('id = ? AND company_id =?', params[:id], current_user.company_id).first
    #if @current_project.blank?
    #  redirect_to log_out_path
    #end
    
    #subsection_list = Subsection.where(:id => params[:template_sections]).collect{|i| i.id}.uniq 
    #subsection_array = Clause.joins(:speclines, :clauseref).where('speclines.project_id' => params[:id]).collect{|i| i.clauseref.subsection_id}.uniq 
    #subsections_to_add = subsection_list- subsection_array

#    speclines_to_add = Specline.joins(:clause => :clauseref
#                              ).where(:project_id => params[:template_id], 'clauserefs.subsection_id' => params[:template_sections]
#                             )

##    speclines_to_add.each do |line_to_add|
#      @new_specline = Specline.new(line_to_add.attributes.merge(:project_id => params[:id]))
#      @new_specline.save
#      @clause_change_record = 3
#      record_new
#    end                   

#     redirect_to(:controller => "projects", :action => "manage_subsections", :id => params[:id], :selected_template_id => params[:template_id])     
#  end


  ##POST
#  def delete_subsections
#    authorize @project 
    #@current_project = Project.where('id = ? AND company_id =?', params[:id], current_user.company_id).first
    #if @current_project.blank?
    #  redirect_to log_out_path
    #end
    
    #subsection_list = Subsection.where(:id => params[:template_sections]).collect{|i| i.id}.uniq
    #subsection_array = Clause.joins(:speclines, :clauseref).where('speclines.project_id' => params[:id]).collect{|i| i.clauseref.subsection_id}.uniq 
    #subsections_to_delete = subsection_array - subsection_list

#    speclines_to_delete = Specline.joins(:clause => :clauseref
#                                  ).where(:project_id => params[:id], 'clauserefs.subsection_id' => params[:project_sections]
#                                  )
    
#    clauses_to_delete = speclines_to_delete.collect{|i| i.clause_id}.uniq.sort

#    speclines_to_delete.each do |line_to_delete|        
#      if line_to_delete.clause_line != 0       
#        @specline = line_to_delete
#        @clause_change_record = 3
#        record_delete              
#      end
#    line_to_delete.destroy
#    end

#    @current_revision = Revision.where('project_id = ?', @current_project.id).last
#    previous_changes_to_clause = Change.where(:project_id => params[:id], :clause_id => clauses_to_delete, :revision_id => @current_revision.id)
#    if !previous_changes_to_clause.blank?
#      previous_changes_to_clause.each do |previous_change|
#      previous_change.clause_add_delete = 3
 #     previous_change.save
#      end    
#    end

#     redirect_to(:controller => "projects", :action => "manage_subsections", :id => params[:id], :selected_template_id => params[:template_id])     
#end





  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:code, :title, :parent_id, :company_id, :project_status, :ref_system, :rev_method, :logo_path, :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at)
    end
end
