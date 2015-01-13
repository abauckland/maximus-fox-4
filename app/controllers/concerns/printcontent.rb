module Printcontent

  def draft_content_page_count(project, revision, settings, pdf)
    content_list_length = 0
    
    project_revisions = Alteration.changed_caws_all_sections(project, revision)
    unless project_revisions.blank?    
      if settings.structure == "group revisions"
        content_list_length = content_list_length + 1
      end    
    end
    
#    if settings.prelim == "single section" 
#      prelim_subsections = Cawssubsection.prelim_subsections(project)
#      if !prelim_subsections.blank?
    content_list_length = content_list_length + 1
#      end  
#    else
#      prelim_subsections = Cawssubsection.prelim_subsections(project)
#      if !prelim_subsections.blank?
#        content_list_length = content_list_length + prelim_subsections.length
#      end             
#    end
    
    subsections = Cawssubsection.subsections(project)    
    content_list_length = content_list_length + subsections.length unless subsections.blank?      
    
    pages = (content_list_length*9)/230

    #content list to cover even number of pages - for double sided printing
    if pages == 0
      pdf.start_new_page 
      pdf.move_down(10)
      pdf.text "[blank page]", :size =>10      
      pdf.start_new_page     
    end
     
    if pages == 1       
      pdf.start_new_page     
      pdf.start_new_page    
    end
    
    if pages == 2
      pdf.start_new_page
      pdf.start_new_page
      pdf.start_new_page      
      pdf.move_down(10)
      pdf.text "[blank page]", :size =>11        
      pdf.start_new_page    
    end

    if pages == 3
      pdf.start_new_page
      pdf.start_new_page
      pdf.start_new_page            
      pdf.start_new_page    
    end    
  end
  
  
  def contents_page(document_content, pdf)

    contents_style = {:size => 11, :border_width => 0}    
    
    pdf.go_to_page(3)

    pdf.bounding_box([0, 270.mm], :width => 492, :height => 255.mm) do
      page_title_header(pdf)    
      pdf.table(document_content, :cell_style => contents_style, :column_widths => [455, 35]) unless document_content.blank?
    end

  end

  def page_title_header(pdf)
    page_title = {:size => 16, :style => :bold}
    
    pdf.move_down(11)
    pdf.text "Document Contents", page_title
    pdf.move_down(20)
  end
 
end