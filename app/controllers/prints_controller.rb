class PrintsController < ApplicationController
  before_action :set_project, only: [:show, :print_project]
  before_action :set_revision, only: [:show, :print_project]

  layout "projects", :except => [:print_project]


  # GET /txt1s/1
  # GET /txt1s/1.xml
  def show
    authorize @project 
    
    #call to protected method that restablishes text to be shown for project revision status
    current_revision_render(@project)
    
    #establish selected revision for project    
    check_changes = Alteration.where(:project_id => @project.id, :revision_id => @revision.id).first    
    if check_changes.blank?
      revision_ids = Revision.where(:project_id => @project.id).order('created_at').ids
      revision_ids.pop
      @revision = Revision.find(:id => revision_ids.last).first
    end
      
    #show if print with superseded
    #check if selected revision has been superseded, i.e. nest revision has been published        
    if @project.project_status == 'Draft'      
      @print_status_show = 'draft'      
    else          
      project_rev_array = @all_project_revisions.collect{|i| i.rev}

      total_revisions = project_rev_array.length        
      selected_revision = project_rev_array.index(@revision.rev)    
      number_revisions_old = total_revisions - selected_revision - 1  
        
      if number_revisions_old > 1
        @print_status_show = 'superseded'
      end  
 
      if number_revisions_old == 1
        @print_status_show = 'issue'    
      end 

      if number_revisions_old == 0
        @print_status_show = 'not for issue'
      end    
    end
  end
  
  
  def print_project
    authorize @project 
        
    #get list of all project revisions
    current_revision_render(@project)
 
    #set water marks to be printed over document
    set_watermark(@project, @revision)

    #update revision status of project if document is not if draft status
    update_revision(@project, @revision)


    ######start of code specific to printing
    ###!!!!!!!!needs updating for variables passed from print view
    
    revision_clause_id_array = Change.select('DISTINCT clause_id').where(:project_id => @current_project.id, :revision_id => @selected_revision.id).collect{|item| item.clause_id}.sort    
    revision_subsection_id_array = Clauseref.joins(:clauses).where('clauses.id' => revision_clause_id_array).collect{|item| item.subsection_id}.sort.uniq    
    



    
    @revision_subsections = Subsection.where(:id => revision_subsection_id_array)

    @revision_prelim_subsections = Subsection.where(:id => revision_subsection_id_array, :section_id => 1)
    revision_prelim_subsection_id_array = @revision_prelim_subsections.collect{|item| item.id}.sort

    @current_clause_id_array = Specline.select('DISTINCT clause_id').where(:project_id => @current_project.id).collect{|item| item.clause_id}.sort       
    current_subsection_id_array = Clauseref.joins(:clauses).where('clauses.id' => @current_clause_id_array).collect{|item| item.subsection_id}.sort.uniq

    @current_subsections = Subsection.where(:id => current_subsection_id_array) 




    @prelim_subsections = Subsection.joins(:subsections => [:clauseref => [:clause => :specline]]
                                    ).where('speclines.project_id' => @project.id
                                    ).where.(:section_id => 1
                                    ).group(:id)
                                     
    @subsections = Subsection.joins(:subsections => [:clauseref => [:clause => :specline]]
                                    ).where('speclines.project_id' => @project.id
                                    ).where.not(:section_id => 1
                                    ).group(:id)  


preliminary_subsections

non_preliminary_subsections



##prelim subsections     
    @added_prelim_subsections = []
    @deleted_prelim_subsections = []
    @changed_prelim_subsections = []

    @added_prelim_clauses = {}
    @deleted_prelim_clauses ={}
    @changed_prelim_clauses = {}

    preliminary_subsections.each_with_index do |subsection, i|

      subsection_change = Alteration.changed_caws_subsections(@project, @revision, subsection)
      
      if subsection_change
        if subsection_change.event == 'new'
          @added_prelim_subsections[i] = subsection
        end
        if subsection_change.event == 'deleted'
          @deleted_prelim_subsections[i] = subsection
        end
      else
        @changed_prelim_subsections[i] = subsection
    
        @added_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('new', @project, @revision, subsection)
        @deleted_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('deleted', @project, @revision, subsection)
        @changed_prelim_clauses[subsection.id] = Clause.changed_caws_clauses('changed', @project, @revision, subsection)
      end
    end
      
##non prelim subsections
    @added_subsections = []
    @deleted_subsections = []
    @changed_subsections = []

    @added_clauses = {}
    @deleted_clauses ={}
    @changed_clauses = {}

    revision_subsections.each_with_index do |subsection, i|

      subsection_change = Alteration.changed_caws_subsections(@project, @revision, subsection)
      
      if subsection_change
        if subsection_change.event == 'new'
          @added_subsections[i] = subsection
        end
        if subsection_change.event == 'deleted'
          @deleted_subsections[i] = subsection
        end
      else
        @changed_subsections[i] = subsection
    
        @added_clauses[subsection.id] = Clause.changed_caws_clauses('new', @project, @revision, subsection)
        @deleted_clauses[subsection.id] = Clause.changed_caws_clauses('deleted', @project, @revision, subsection)
        @changed_clauses[subsection.id] = Clause.changed_caws_clauses('changed', @project, @revision, subsection)
      end
    end
 
 
 
    if @current_revision_project_status != @previous_revision_project_status
        @project_status_changed = true
    end

   
   
    if @revision.rev.blank?
      @print_revision_rev = 'n/a'
    else
      @print_revision_rev = @revision.rev.capitalize
    end
    
    @company = Company.find(current_user.company_id) 
   
    @font = "Times-Roman"
    #@font = "Helvetica"
    @font_space = "7.mm"
   
    #respond_to do |format|
    #  format.pdf  {render :layout => false}
      prawnto :filename => @current_project.code+"_rev_"+@print_revision_rev+".pdf", :prawn => {:page_size => "A4", :margin => [20.mm, 14.mm, 5.mm, 20.mm]}, :inline=>false     
    #end
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
 
  
  def set_watermark(project, revision)
    
    @superseded = []    
    @watermark = [] 
    if project.project_status == 'Draft'
      
      @watermark[0] = 1 #show
      @superseded[0] = 2 #do not show
      
    else
       
      project_rev_array = Revision.where('project_id = ?', project.id).order('created_at').pluck(:rev) 
          
      total_revisions = project_rev_array.length        
      selected_revision = project_rev_array.index(revision.rev)    
      number_revisions_old = total_revisions - selected_revision - 1  
        
      if number_revisions_old > 1
        @superseded[0] = 1
        @watermark[0] = 2 #do not show
      end  
 
      if number_revisions_old == 1
        @watermark[0] = 2 #do not show
        @superseded[0] = 2 #do not show     
      end 

      if number_revisions_old == 0
        if params[:issue] == 'true'
          @watermark[0] = 1 #show
          @superseded[0] = 2 #do not show      
        else
          @watermark[0] = 2 #do not show
          @superseded[0] = 2 #do not show        
        end
      end     
    end
  end

  
  def update_revision(project, revision)

    ###update revision status of project if document is not if draft status
    if project.project_status != 'Draft'                
      current_revision = Revision.where(:project_id => project.id).last      
      #ifthe current revision of the project has been selected to print
      if revision.rev == current_revision.rev               
        #change project revision number if there are changes to made to the project speclines since last revision
        check_revision_use = Alteration.where(:project_id => project.id, :revision_id => current_revision.id).first
        if !check_revision_use.blank?  #if there are revisions
          next_revision_ref = current_revision.rev.next          
        else
        #if no changes but project has not been issued before then change revision ref to 'a'  
          if revision.rev == '-'
            next_revision_ref = 'a' 
          #if project has been issued before but no changes have been made to project speclines
          else  
            #change project revision number if the project status has changed
            check_project_status_change(project, revision)
            #@if project status changed got from above method            
            if @project_status_changed == true
              next_revision_ref = current_revision.rev.next
            end             
          end  
        end
        @new_rev_record = Revision.create(:rev => next_revision_ref, :project_id => project.id, :user_id => current_user.id, :date => Date.today)                                      
      end
      @current_revision_rev = current_revision.rev.capitalize       
    end    
  end


end