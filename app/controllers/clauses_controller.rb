class ClausesController < ApplicationController

before_action :set_project, only: [:new, :create, :new_clone_subsection_list, :new_clone_clause_list]

layout "projects"

#new clause create code
#need to set up route and carry over variables
  def new   
    
    @clause = Clause.new
    clausetitle = @clause.build_clausetitle
    clauseref = @clause.build_clauseref
        
    if @project.ref_system.caws?    
      @subsection = Cawssubsection.where(:id => params[:subsection_id]).first
    else
###uniclass code to go here - same as above 
    end
  end


  def create        
    @clause = Clause.new(params[:clause])

    current_clauseref = Specline.joins(:clause => :clauseref
                               ).where(:project_id => @project, 
                               'clauserefs.subsection_id' => params[:clause][:clauseref_attributes][:subsection_id], 
                               'clauserefs.clausetype_id' => params[:clause][:clauseref_attributes][:full_clause_ref][0,1], 
                               'clauserefs.clause' => params[:clause][:clauseref_attributes][:full_clause_ref][1,2], 
                               'clauserefs.subclause' => params[:clause][:clauseref_attributes][:full_clause_ref][3,1]
                               ).first
    

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
        
        #get information on content to be created
        clausetype_id = params[:clause][:clauseref_attributes][:full_clause_ref][0,1]
        case clausetype_id
          when '1', '6', '7', '8', '10', '11', '12' ;  @linetype_id = 7
          when '2', '3', '4', '5' ;  @linetype_id = 8
        end
                          
        if params[:clause_content] == 'blank_content'              
          @new_specline = Specline.create(:project_id => @project.id, :clause_id => @clause.id, :clause_line => 0, :linetype_id => @linetype_id)
        else   
          clone_speclines = Specline.where('clause_id = ? AND project_id = ? AND clause_line > ?', params[:clone_clause_id], params[:clone_template_id], 0)         
          clone_speclines.each do |clone_line|
            @new_specline = Specline.create(clone_line.attributes.merge({:project_id => @project.id, :clause_id => @clause.id}))      
          end            
        @clause_change_record = 2
        record_new(@new_specline, clause_change_record)
        end
         
        redirect_to(:controller => "speclauses", :action => "manage", :id => @project.id, :subsection_id => params[:clause][:clauseref_attributes][:subsection_id])
      else
        respond_to do |format|
          format.html { render :action => "new"}
          format.xml  { render :xml => @clause.errors, :status => :unprocessable_entity }
        end
      end 
    end
  end


    
  private
    # Use callbacks to share common setup or constraints between actions.    
    def set_project
      @project = Project.find(params[:id])
    end

    def new_clone_project_list
      @projects = Project.user_projects(current_user).order("company_id, code")   
    end
  
    def new_clone_subsection_list
      if @project.ref_system.caws?    
        @clone_subsections = Cawssubsection.project_subsections(@project)
      else
###uniclass code to go here - same as above 
      end
    end
  
    def new_clone_clause_list
      if @project.ref_system.caws?      
        @clone_clauses = Clause.joins(:speclines, :clauseref => [:subsection]
                              ).where('speclines.project_id' => @project.id, 'subsections.cawssubsection_id' => params[:subsection]
                              ).order('subsections.cawssubsection_id', 'clauserefs.clausetype_id', 'clauserefs.clause', 'clauserefs.subclause')    
      else
###uniclass code to go here - same as above 
      end    
    end

#end of class
end