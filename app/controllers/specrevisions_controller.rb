class SpecrevisionsController < ApplicationController
  before_action :set_project, only: [:show, :show_prelim_tab_content, :show_rev_tab_content]
  before_action :set_revision, only: [:show, :show_prelim_tab_content, :show_rev_tab_content]

  layout "projects"

  def show    
    authorize @project 
        
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)  
       
    #check if status of the project has changed since last revision    
    check_project_status_change(@project, @revision)


    if @project.ref_system.caws?
#list of tabs that can be seen should depend on the scope of the user

      #get list of susbections that can be access by user
      #governed by the level of access given to them in subsectionusers table
      #if user not list against any subsections they will be able to see all subsection in project
      authorised_subsection_ids(project)

      #tab menu - estabished list of subsections with revisions    
      @subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                        ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                        ).where('subsections.id' => @authorised_subsection_ids
                                        ).group(:id)


      @prelim_subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                        ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                        ).where('subsections.id' => @authorised_subsection_ids
                                        ).where(:cawssection_id => 1
                                        ).group(:id)
    
      @non_prelim_subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                        ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id
                                        ).where('subsections.id' => @authorised_subsection_ids
                                        ).where.not(:cawssection_id => 1
                                        ).group(:id)
     
      ##prelim subsections
      if @prelim_subsections
        #get list of prelim subsections in project where changes have been made   
        prelim_cawssubsection_change_data(@project, @prelim_subsections, @revision)         
      ##non prelim subsections
      else
        @subsection = @subsections.first.id     
        #establish if subsection is new or has been deleted      
        cawssubsection_change_data(@project, @subsection, @revision)
      end
    else    
###uniclass code to go here - same as above       
    end    
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @revision }
    end
  end


  def show_prelim_tab_content
    authorize @project 

    if @project.ref_system.caws?        
      prelim_subsections = Cawssubsection.joins(:subsections => [:clauserefs => [:clause => :alterations]]
                                        ).where('alterations.project_id' => @project.id, 'alterations.revision_id' => @revision.id, :cawssection_id => 1
                                        ).group(:id)      
      #establish if subsection is new or has been deleted 
      prelim_cawssubsection_change_data(@project, prelim_subsections, @revision)
    else    
###uniclass code to go here - same as above       
    end

    respond_to do |format|
      format.js  { render :show_rev_tab_content_prelim, :layout => false } 
    end    
  end


  def show_rev_tab_content    
    authorize @project  
    
    if @project.ref_system.caws?    
      subsection = Cawssubsection.find(params[:subsection_id])             
      cawssubsection_change_data(@project, subsection, @revision)
    else    
###uniclass code to go here - same as above       
    end 
        
    respond_to do |format|        
      format.js  { render :show_rev_tab_content, :layout => false } 
    end    
  end



  private

    def set_project
      @project = Project.find(params[:id])
    end

    def set_revision
      if params[:revision_id].blank?
        @revision = Revision.where(:project_id => params[:id]).order('created_at').last
      else
        @revision = Revision.find(params[:revision_id])
      end
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def prelim_cawssubsection_change_data(project, prelim_subsections, revision)

      @deleted_prelim_subsections = []
      @added_prelim_subsections = []
      @changed_prelim_subsections = []

      @deleted_prelim_clauses ={}
      @added_prelim_clauses = {}
      @changed_prelim_clauses = {}

      #check if prelim subsection is new, added or changed
      prelim_subsections.each_with_index do |subsection, i|

        subsection_change = Alteration.changed_caws_subsections(project, revision, subsection)
      
        if subsection_change
          if subsection_change.event == 'new'
            @added_prelim_subsections[i] = subsection
          end
          if subsection_change.event == 'deleted'
            @deleted_prelim_subsections[i] = subsection
          end
        else
          @changed_prelim_subsections[i] = subsection

          @deleted_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('new', project, revision, subsection)
          @added_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('deleted', project, revision, subsection)
          @changed_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('changed', project, revision, subsection)
        end 
      end        
    end


    def cawssubsection_change_data(project, subsection, revision)
      subsection_change = Alteration.changed_caws_subsections(project, revision, subsection) 
      
      if subsection_change
        if subsection_change.event == 'new'
          @added_subsections = subsection
        end
        if subsection_change.event == 'deleted'
          @deleted_subsections = subsection
        end
      else

      #check status of clause within changed subsection           
        @added_clauses = Clause.changed_caws_clauses('new', project, revision, subsection)
        @deleted_clauses = Clause.changed_caws_clauses('deleted', project, revision, subsection)
        @changed_clauses = Clause.changed_caws_clauses('changed', project, revision, subsection)
      end  
    end
end
