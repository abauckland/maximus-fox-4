class PrintsController < ApplicationController

  before_filter :authenticate
  before_action :set_project, only: [:show, :print_project]
  before_action :set_revision, only: [:show, :print_project]

  layout "projects", :except => [:print_project]

  require "prawn"
  require "prawn/measurement_extensions"  
  require "prawn/table"

  include Printtemplate        

  # GET /txt1s/1
  # GET /txt1s/1.xml
  def show
    
    @revisions = Revision.where(:project_id => params[:id]).order('created_at')

    #show if print with superseded
    #check if selected revision has been superseded, i.e. nest revision has been published        
    if @project.project_status == 'Draft'      
      @print_status_show = 'draft'      
    else          
      project_rev_array = @revisions.collect{|i| i.rev}

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
  



  def print_download
  
    current_revision = Revision.where(:project_id => @project.id).order('created_at').last 
#current verision equals current unplublihsed version
#if current verision has no new revisions do not apply superseded watermark    
    if @revision == current_revision
      print_project
    else
      @print = Print.where(:project_id => @project.id, :revision_id => @revision.id).first

      #send copy of the saved document
      send_file @print.document.path
    end   
  end

  
  def print_project
            
   document = Prawn::Document.new(
    :page_size => "A4",
    :margin => [20.mm, 14.mm, 20.mm, 20.mm],
    :info => {:title => @project.title}
    ) do |pdf|    
        if @project.CAWS?
            print_caws_document(@project, @revision, pdf)
        else
            print_uni_document(@project, @revision, pdf)
        end            
    end        
    
    #update revision status of project if document is not if draft status
    update_revision(@project, @revision) unless params[:issue].present?
    
    if @revision.rev
      case @revision.rev
      when '' ; filename = "#{@project.code}_rev_na.pdf" 
      when '-'; filename = "#{@project.code}_rev_-.pdf"
      else 
        filename = "#{@project.code}_rev_#{@revision.rev.upcase}.pdf"      
      end
    else
      filename = "#{@project.code}_rev_na.pdf"   
    end

##THIS IS NOT WORKING - PARAMS NOT CORRECT
    unless params[:issue].present?
      unless @project.Draft?      
          
          document.render_file(filename)
          @print = Print.create(:project_id => @project.id,
                                :revision_id => @revision.id,
                                :user_id => current_user.id)
          scr = File.join(Rails.root, filename)
          scr_file = File.new(scr)                      
          @print.issued = scr_file  
          @print.save
      
          send_data scr_file, filename: filename, :type => "application/pdf"          
      else
          send_data document.render, filename: filename, :type => "application/pdf"
      end
    else
      send_data document.render, filename: filename, :type => "application/pdf"  
    end
##clean tem directory in crontab
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
  def print_params
    params.require(:print).permit(:project_id, :revision_id, :user_id, :print, :document, :created_at, :updated_at)
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
        @new_rev_record = Revision.create(:rev => next_revision_ref, :project_status => project.project_status, :project_id => project.id, :user_id => current_user.id, :date => Date.today)                                      
      end
      @current_revision_rev = current_revision.rev.capitalize       
    end    
  end


end