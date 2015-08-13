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

    if issue == "draft" || issue == "audit"
      @watermark = 1 #show
    else
      @watermark = 2 #do not show
    end

  end

end