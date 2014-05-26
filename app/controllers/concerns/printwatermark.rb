module Printwatermark

  def watermark_helper(project, revision, pdf)
    
    set_watermark(project, revision)
    
    watermark_style = {:width => 250.mm, :size => 108, :style => :bold, :at => [20.mm,55.mm], :rotate => 60}
    
    if watermark[0].to_i == 1
      pdf.transparent(0.15) do
        pdf.text_box "not for issue", watermark_style
      end
    end
    if superseded[0].to_i == 1
      pdf.transparent(0.15) do
        pdf.text_box "superseded", watermark_style
      end
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





end