class PrintsController < ApplicationController
  before_filter :authenticate
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
    
    @revisions = Revision.where(:project_id => params[:id]).order('created_at')

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
  



  def print_download
  
    current_revision Revision.where(:project_id => @project.id).order('created_at').last 
#current verision equals current unplublihsed version
#if current verision has no new revisions do not apply superseded watermark    
    if @revision == current_revision
      print_project
    else
      pdf_document = Print.where(:project_id => @project.id, :revision_id => @revision.id).first
      #open document and apply superseded water mark to all pages
      
      
      filename = pdf_document.attachment
      Prawn::Document.generate("#{@project.code}_rev_#{@revision.rev.capitalize}.pdf", :template => filename) do
        
        settings = Printsetting.where(:project_id => project.id).first
        pdf.font "#{settings.font_style}"
        
        watermark_style = {:width => 250.mm, :size => 108, :style => :bold, :at => [20.mm,55.mm], :rotate => 60}
        
        pdf.transparent(0.15) do
          pdf.text_box "superseded", watermark_style
        end
        
      end
    end
    
  end

  
  def print_project
        
   document = Prawn::Document.new(
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

    
    filename = "#{@project.code}_rev_#{@revision.rev.capitalize}.pdf"
    document.render_file "tmp/#{filename}"

    print_file = Print.create(:attachment => LocalFile.new(RAILS_ROOT + "/tmp/#{filename}"), :project_id => @project.id, :revision_id => @revision, :user_id => current_user.id)

    return filename

  #  redirect_to print_path(@project.id)

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