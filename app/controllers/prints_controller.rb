class PrintsController < ApplicationController
  before_action :set_project, only: [:show, :print_project]
  before_action :set_revision, only: [:show, :print_project]

  layout "projects", :except => [:print_project]

  require "prawn"
  require "prawn/measurement_extensions"

  include Printtemplate        

  # GET /txt1s/1
  # GET /txt1s/1.xml
  def show
    
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
        
    Prawn::Document.generate("#{@project.code}_rev_#{@revision.rev.capitalize}.pdf",
      :page_size => "A4",
      :margin => [20.mm, 14.mm, 5.mm, 20.mm],
      :info => {:title => @project.title}
    ) do |pdf|
    
        if @project.ref_system.caws?
            print_caws_document(@project, @revision, pdf)
        else
            print_uni_document(@project, @revision, pdf)
        end
            
    end        

    #update revision status of project if document is not if draft status
    update_revision(@project, @revision)

    redirect_to print_path(@project.id)

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
            if @status_changed == true
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