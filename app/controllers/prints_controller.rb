class PrintsController < ApplicationController

  before_action :set_project, only: [:show, :print_project]
  before_action :set_revision, only: [:show, :print_project]

  include ProjectuserDetails
  include RefsystemSettings

  layout "projects", :except => [:print_project]

  require "prawn"
  require "prawn/measurement_extensions"
  require "prawn/table"

  include Printtemplate

  # GET /txt1s/1
  # GET /txt1s/1.xml
  def show
    authorize :print, :show?

    check_alterations = Alteration.all_changes(@project, @revision).first
    if check_alterations.blank?
      @revisions = Revision.where(:project_id => params[:id]).where.not(:id => @revision.id).order('created_at')
    else
      @revisions = Revision.where(:project_id => params[:id]).order('created_at')
    end


    #show if print with superseded
    #check if selected revision has been superseded, i.e. next revision has been published
    if @project.project_status == 'Draft'
      @print_status_show = 'draft'
    else
      if @revisions.count >= 1
        project_rev_array = @revisions.collect{|i| i.rev}

        total_revisions = project_rev_array.length
        
        if project_rev_array.include?(@revision.rev)
          selected_revision = project_rev_array.index(@revision.rev)
          number_revisions_old = total_revisions - selected_revision - 1

          @print_status_show = case number_revisions_old
            when 0 ; 'not for issue'
            when 1 ; 'issue'
            else
              'superseded'
          end

        else
          @print_status_show = 'issue'
        end
      else
        @print_status_show = 'not for issue'
      end
    end
  end




  def print_project
    authorize :print, :print_project?

#    selected_revision = Revision.find(params[:revision_id]) if !params[:revision_id].blank?
    last_revision = Revision.where(:project_id => @project.id).order('created_at').last

    check_alterations = Alteration.all_changes(@project, last_revision).first
    if check_alterations.blank?

      revision_count = Revision.where(:project_id => params[:id]).count
      if revision_count == 1
        current_revision = last_revision
      else
        current_revision = Revision.where(:project_id => params[:id]).where.not(:id => last_revision.id).order('created_at').last
      end

    else
      current_revision = last_revision
    end


    if current_revision == last_revision && @project.project_status != 'Draft'
    #update revision status of project if document is not if draft status
      update_revision(@project, current_revision) if params[:issue] == "final"
    else
      check_project_status_change(@project, current_revision)
      if @project_status_changed == true
        update_revision(@project, current_revision) if params[:issue] == "final"
      end
    end

    print_download(current_revision, params[:issue])

  end


private

    def print_download(revision, issue)

     document = Prawn::Document.new(
      :page_size => "A4",
      :margin => [20.mm, 14.mm, 5.mm, 20.mm],
      :info => {:title => @project.title}
      ) do |pdf|
        print_document(@project, revision, issue, pdf)
      end

      case revision.rev
      when nil ; filename = "#{@project.code}_rev_na.pdf"
      when '-'; filename = "#{@project.code}_rev_-.pdf"
      else
        filename = "#{@project.code}_rev_#{revision.rev.upcase}.pdf"
      end

      send_data document.render, filename: filename, :type => "application/pdf"
    end

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
      params.require(:print).permit(:project_id, :revision_id, :user_id, :print, :issue, :created_at, :updated_at)
    end


    def update_revision(project, revision)

      #if no changes but project has not been issued before then change revision ref to 'a'
      if revision.rev == '-'
        next_revision_ref = 'a'
      else
        next_revision_ref = revision.rev.next
      end

      new_revision = revision.dup
      new_revision.save
      new_revision.update(:rev => next_revision_ref)

    end

end