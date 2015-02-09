module Printwatermark

  def watermark_helper(project, revision, issue, pdf)

    set_watermark(issue)

    watermark_style = {:width => 250.mm, :size => 108, :style => :bold, :at => [20.mm,75.mm], :rotate => 60}

    if @watermark == 1
      pdf.repeat(:all, :dynamic => true) do;
        pdf.transparent(0.15) do
          pdf.text_box "not for issue", watermark_style
        end
      end
    end
  end


  def set_watermark(issue)

    if issue == "draft"
      @watermark = 1 #show
    else
      @watermark = 2 #do not show
    end

#    if project.project_status == 'Draft'
#      @watermark = 1 #show
#    else

#      project_rev_array = Revision.where('project_id = ?', project.id).order('created_at').pluck(:rev)

#      total_revisions = project_rev_array.length
#      selected_revision = project_rev_array.index(revision.rev)
#      number_revisions_old = total_revisions - selected_revision - 1

#      if number_revisions_old == 0
#        if params[:issue] == 'true'
#          @watermark = 1 #show
#        else
#          @watermark = 2 #do not show
#        end
#      else
#        @watermark = 2 #do not show
#      end
#    end
#   end
  end

end