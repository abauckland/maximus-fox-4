class ClausesController < ApplicationController


#  before_filter :authenticate
  before_action :set_project, only: [:new, :create, :new_clone_project_list, :new_clone_subsection_list, :new_clone_clause_list]

  layout "projects"


  def new
    
    @clause = Clause.new
    clausetitle = @clause.build_clausetitle
    clauseref = @clause.build_clauseref
        
    if @project.CAWS?
      @subsection = Cawssubsection.where(:id => params[:subsection_id]).first
    else
###uniclass code to go here - same as above
    end
  end



  def create
    @clause = Clause.new(clause_params)

    current_clauseref = Specline.joins(:clause => :clauseref
                               ).where(:project_id => @project.id, 
                               'clauserefs.subsection_id' => params[:clause][:clauseref_attributes][:subsection_id], 
                               'clauserefs.clausetype_id' => params[:clause][:clauseref_attributes][:full_clause_ref][0,1], 
                               'clauserefs.clause_no' => params[:clause][:clauseref_attributes][:full_clause_ref][1,2], 
                               'clauserefs.subclause' => params[:clause][:clauseref_attributes][:full_clause_ref][3,1]
                               ).first

    if @project.CAWS?
      @subsection = Cawssubsection.where(:id => params[:clause][:clauseref_attributes][:subsection_id]).first
    else
###uniclass code to go here - same as above 
    end

    if !current_clauseref.blank?
      flash.now[:error] = 'A clause with the same reference already exists in this Work Section'        
      respond_to do |format|
        format.html { render :action => "new"}
        format.xml  { render :xml => @clause.errors, :status => :unprocessable_entity }
      end
    else

      if @clause.save
        #create title line
        @new_specline = Specline.create(:project_id => @project.id, :clause_id => @clause.id, :clause_line => 0, :linetype_id => 1)
        #create change record for new clause title line
        record_new(@new_specline, event_type) 

        #get information on content to be created
        clausetype_id = params[:clause][:clauseref_attributes][:full_clause_ref][0,1]
        case clausetype_id
          when '1', '6', '7', '8', '10', '11', '12' ;  @linetype_id = 7
          when '2', '3', '4', '5' ;  @linetype_id = 8
        end

        if params[:clause_content] == 'blank_content'
          @new_specline = Specline.create(:project_id => @project.id, :clause_id => @clause.id, :clause_line => 1, :linetype_id => @linetype_id)
          #create change record for line
          record_new(@new_specline, event_type)
        else   
          clone_speclines = Specline.where(:clause_id => params[:clone_clause_id], :project_id => params[:clone_template_id]).where.not(:clause_line => 0)         
          clone_speclines.each do |clone_line|
            @new_specline = Specline.create(clone_line.attributes.merge(:id => nil, :project_id => @project.id, :clause_id => @clause.id))      
            #create change record for each new line
            record_new(@new_specline, event_type)
          end
        end

        redirect_to manage_specclause_path(:id => @project.id, :subsection_id => params[:clause][:clauseref_attributes][:subsection_id])
      else
        respond_to do |format|
          format.html { render :action => "new", :id => @project.id, :subsection_id => params[:clause][:clauseref_attributes][:subsection_id]}
          format.xml  { render :xml => @clause.errors, :status => :unprocessable_entity }
        end
      end
    end
  end


  def new_clone_project_list
    #projects must contain something
    user_projects = Specline.joins(:project => :projectusers
                            ).where('projectusers.user_id' => current_user.id, 'projects.ref_system' => @project.ref_system
                            ).pluck(:project_id).uniq.sort
#    user_projects = Project.user_projects_access(current_user).ref_system(@project).order("code").ids
    standard_templates = Project.where(:id => [1..10], :ref_system => @project.ref_system).order("code").ids
    template_ids = user_projects + standard_templates

    @projects = Project.where(:id => template_ids)

  end

  def new_clone_subsection_list

      if @project.CAWS?
        #if user is identified as having access to only some subsections return list of subsections
        #if user has access to all, return all subsections for project
        subsectionuser_ids = Subsectionuser.joins(:projectuser
                                      ).where('projectusers.user_id' => current_user.id, 'projectusers.project_id' => @project.id
                                      ).ids
        
        if subsectionuser_ids.blank?
          clone_subsection_ids = Cawssubsection.project_subsections(@project).order("id").ids.uniq
        else
          clone_subsection_ids = Cawssubsection.joins(:subsections => :subsectionusers
                                            ).where('subsectionusers.id' => subsectionuser_ids 
                                            ).ids.uniq
        end
        @clone_subsections = Cawssubsection.includes(:cawssection).where(:id => clone_subsection_ids).order('cawssections.ref, cawssubsections.ref')        
      else
###uniclass code to go here - same as above
      end
  end

  def new_clone_clause_list
      if @project.CAWS?     
        clone_clause_ids = Clause.joins(:speclines, :clauseref => [:subsection]
                              ).where('speclines.project_id' => @project.id, 'subsections.cawssubsection_id' => params[:subsection]
                              ).ids.uniq    
        @clone_clauses = Clause.includes(:clausetitle, :clauseref => [:subsection => [:cawssubsection => :cawssection]]).where(:id => clone_clause_ids).order('clauserefs.subsection_id', 'clauserefs.clausetype_id', 'clauserefs.clause_no', 'clauserefs.subclause')          
      else
###uniclass code to go here - same as above 
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def clause_params
      params.require(:clause).permit({:clauseref_attributes => [:subsection_id, :full_clause_ref]}, :project_id, :title_text)
    end

    def event_type
      #indicate type event that addition of the specline is associated with
      #1 => line added/deleted/changed
      #2 => clause added/deleted
      #3 => subsection added/deleted
      #information used in reporting changes to the document
      return 2
    end

#end of class
end