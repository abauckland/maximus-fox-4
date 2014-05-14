section_revision_subtitle
prelim_cover
section_cover
section_revisions_title_1
section_revisions_title_2
section_specification_title_1
section_specification_title_2
prelim_revision_subtitle
prelim_specification_subtitle

def prelim_subsection_print(subsection, pdf)
#font styles for page  
  font_style_clausetype_code = {:size => 11, :style => :bold}
#formating for lines  
  clausetype_code_format = font_style_clausetype_code
  clausetype_title_format = font_style_clausetype_code.merge(:width => 155.mm, :overflow => :expand)

      pdf.move_down(6.mm)         
      pdf.spec_box subsection.section.ref + sprintf("%02d", subsection.ref).to_s, clausetype_code_format.merge(:at =>[0.mm, pdf.y])
      pdf.spec_box subsection.text.upcase, clausetype_title_format.merge(:at =>[20.mm, pdf.y])
      pdf.move_down(pdf.box_height)
end