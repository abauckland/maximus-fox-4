module Printcontent

  def contents_page(subsection_pages, pdf)
    
    pdf.go_to_page(1)

    page_title_header(pdf)

    subsection_pages.each do |page|
      subsection(page, pdf)
    end
  end


  def page_title_header(pdf)
    page_title = {:size => 16, :style => :bold}
    
    pdf.move_down(11)
    pdf.text "Document Contents", page_title
    pdf.move_down(23)
  end


  def section(page, pdf)
    contents_style = {:size => 12, :leading => 2.mm}
    
    pdf.text page[:subsection], contents_style.merge(:align => :left)
    pdf.text page[:number], contents_style.merge(:align => :right)
    #if list of contents does not fit on page start new page
    if pdf.y <= 30.mm
      pdf.text "List of Contents continued on next page...", :size => 10, :style => :italic
      pdf.start_new_page
      pdf.move_down(11)
      pdf.text "Document Contents (continued)", :size => 14, :style => :bold_italic
      pdf.move_down(23)
    end
  end  


#  def revision(contents_style)
#  pdf.text "Document Revisions", contents_style  
#  end  


#  def prelim_section(project, contents_style)
#    if project.ref_system.caws?
#      pdf.text "A-- Preliminaries", contents_style
#    else
#      pdf.text "A-- Preliminaries", contents_style
##    end  
#  end


  
end  
  
  
