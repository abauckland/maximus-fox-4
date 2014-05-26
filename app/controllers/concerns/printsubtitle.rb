module Printsubtitle

#section title where revisions all in one section at front of document
def revision_cover(pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box "Document Revisions", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
end

def project_status_change(previous_status, current_status, pdf)
  pdf.spec_box "Document Status Changed from #{previous_status} to #{current_status}:", :size => 11, :at => [0.mm, pdf.y], :width => 165.mm, :height => 7.mm;
  pdf.move_down(pdf.box_height + 2.mm)
end


def revision_prelim_title(pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box "A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
  pdf.move_down(3.mm)   
end

def revision_prelim_subtitle(subsection, pdf)
  section_cover_style = {:size => 9, :style => :bold}
  
  pdf.move_down(3.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end

def revision_title(subsection, pdf)
  subtitle_cover_style = {:size => 9, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
  pdf.move_down(3.mm) 
end







#where prelims are grouped together
def prelim_caws_cover(pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box "A-- Preliminaries", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
end


def prelim_caws_revision_title(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.spec_box "Revisions to Section", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end


def prelim_caws_revision_subtitle(subsection, pdf)
  section_cover_style = {:size => 9, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box "Revisions to #{subsection.full_code}", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end


def prelim_caws_specification_title(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.spec_box "Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)   
end  

def prelim_caws_specification_subtitle(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height) 
end






def section_cover(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)
end

def caws_revision_title(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.spec_box "Revisions to Section", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end


def caws_revision_subtitle(subsection, pdf)
  section_cover_style = {:size => 9, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box "Revisions to #{subsection.full_code}", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)  
end


def caws_specification_title(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.spec_box "Specification", section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height)   
end  

def caws_specification_subtitle(subsection, pdf)
  section_cover_style = {:size => 11, :style => :bold}
  
  pdf.move_down(6.mm) 
  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[0.mm, pdf.y])
  pdf.move_down(pdf.box_height) 
end


end