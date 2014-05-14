

def contents_page(project, revision, pages)

#font styles for page  
  page_title = {:size => 16, :style => :bold}
  contents_style = {:size => 12, :leading => 2.mm}

  page_title_header(page_title)

  if rev.document?
    revision
  end

  if prelims.combined?
    prelim_section(project, contents_style) 
  else
    prelim_sections = Subsection.where()
    prelim_sections.each do |section|
      section(section)  
    end
  end 
  sections = Subsection.where()
  sections.each do |section|
    section(section)
  end

end


def page_title_header(page_title)
  pdf.move_down(11)
  pdf.text "Document Contents", page_title
  pdf.move_down(23)
end


def revision(contents_style)
  pdf.text "Document Revisions", contents_style  
end  


def prelim_section(project, contents_style)
  if project.ref_system.caws?
    pdf.text "A-- Preliminaries", contents_style
  else
    pdf.text "A-- Preliminaries", contents_style
  end  
end


def section(section, contents_style)
    pdf.text subsection.full_code_and_title, contents_style
    #if list of contents does not fit on page start new page
    if pdf.y <= 30.mm
      pdf.text "List of Contents continued on next page...", :size => 10, :style => :italic
      pdf.start_new_page
      pdf.move_down(11)
      pdf.text "Document Contents (continued)", :size => 14, :style => :bold_italic
      pdf.move_down(23)
    end
end  
  
  
  
  
