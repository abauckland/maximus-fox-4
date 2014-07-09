module Printsubtitle

  #section title where revisions all in one section at front of document
  def revision_cover(pdf)
    section_cover_style = {:size => 11, :style => :bold}
    
    pdf.move_down(8.mm) 
    pdf.spec_box "Document Revisions", section_cover_style.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height)
  end
  
  def project_status_change(previous_status, current_status, pdf)
    pdf.spec_box "Document Status Changed from #{previous_status} to #{current_status}:", :size => 11, :at => [0.mm, pdf.y], :width => 165.mm, :height => 7.mm;
    pdf.move_down(pdf.box_height + 2.mm)
  end


def revision_prelim_title(pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(8.mm) 
  pdf.spec_box "A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
  pdf.move_down(3.mm)   
end

def revision_prelim_subtitle(subsection, pdf)
  section_cover_style = {:size => 9, :style => :bold}
  
  pdf.move_down(8.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end

def revision_title(subsection, pdf)
  subtitle_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(8.mm) 
  pdf.spec_box subsection.full_code_and_title, subtitle_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
  pdf.move_down(3.mm) 
end







#where prelims are grouped together
def prelim_caws_cover(pdf)
  section_cover_style = {:size => 18, :style => :bold}
  
  pdf.move_down(8.mm) 
  pdf.spec_box "A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
end

#combined_prelim_caws_revision_title
#combined_prelim_caws_specification_title
def combined_prelim_caws_title(category, pdf)
  section_cover_style = {:size => 14, :style => :bold}
  
  pdf.move_down(8.mm) 
  if category == "revision"
    pdf.spec_box "Revisions to A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  else
    pdf.spec_box "A-- Preliminaries Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])      
  end
  pdf.move_down(pdf.box_height)  
end

def combined_prelim_caws_subtitle(category, pdf)
  section_cover_style = {:size => 14, :style => :bold}
  
  pdf.move_down(8.mm) 
  #pdf.spec_box "A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  #pdf.move_down(pdf.box_height)
  if category == "revision"
    pdf.spec_box "Revisions to A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  else
    pdf.spec_box "Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])      
  end
  pdf.move_down(pdf.box_height) 
end





  def prelim_caws_title_type(settings, subsection, category, pdf)
    if settings.section_cover == "section cover"
      #if there is a cover for prelims
      prelim_caws_subtitle(subsection, category, pdf)
    else
      #if there is no cover
      prelim_caws_title(subsection, category, pdf)
    end     
  end
  
  #prelim_caws_revision_title
  #prelim_caws_specification_title
  def prelim_caws_title(subsection, category, pdf)
    section_cover_style = {:size => 14, :style => :bold}
    
    pdf.move_down(8.mm) 
    pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height)
#    if category == "revision"
#      pdf.spec_box "Revisions to Section", section_cover_style.merge(:at =>[0.mm, pdf.y])
#    else
#      pdf.spec_box "Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])     
#    end  
#    pdf.move_down(pdf.box_height)  
  end
  
  #prelim_caws_revision_subtitle
  #prelim_caws_specification_subtitle
  def prelim_caws_subtitle(subsection, category, pdf)
    section_cover_style = {:size => 9, :style => :bold}
    
    pdf.move_down(8.mm) 
    if category == "revision"
      pdf.spec_box "Revisions to #{subsection.full_code}", section_cover_style.merge(:at =>[0.mm, pdf.y])
    else
      pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])  
    end 
    pdf.move_down(pdf.box_height)  
  end





  def section_cover(subsection, pdf)
    section_cover_style = {:size => 16, :style => :bold}
    
    pdf.move_down(8.mm) 
    pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height)
  end


  def caws_title_type(settings, subsection, category, pdf)
    if settings.section_cover == "section cover"
      #if there is a cover for prelims
      caws_subtitle(subsection, category, pdf)
    else
      #if there is no cover
      caws_title(subsection, category, pdf)
    end     
  end
  
  #caws_revision_title
  #caws_specification_title
  def caws_title(subsection, category, pdf)
    section_cover_style = {:size => 14, :style => :bold}
    
    pdf.move_down(8.mm) 
    pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
    pdf.move_down(pdf.box_height)
    if category == "revision"
      pdf.spec_box "Revisions to Section", section_cover_style.merge(:at =>[0.mm, pdf.y])
    else
      pdf.spec_box "Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])    
    end   
    pdf.move_down(pdf.box_height)   
  end  

  #caws_revision_subtitle
  #caws_specification_subtitle
  def caws_subtitle(subsection, category, pdf)
    section_cover_style = {:size => 11, :style => :bold}
    
    pdf.move_down(8.mm) 
    if category == "revision"
      pdf.spec_box "Revisions to #{subsection.full_code}", section_cover_style.merge(:at =>[0.mm, pdf.y])
    else
      pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])   
    end 
    pdf.move_down(pdf.box_height)  
  end



end