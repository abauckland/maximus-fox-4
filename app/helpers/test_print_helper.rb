
#cover page
#cover - title

#cover - image

#cover - details

#issue sheet

#contents page

#document

revision_method
#=> by documeent
#=> by section

prelim_method
#=> combined into one section
#=> separate sections

section_method
#=> cover
#=> no cover

page_numbering
#=> by document
#=> by section

quality_control
#=> section covers
#=> document covers

font_type
#=> helvetica
#=> Times
#=> another
#=> another

font_size
#=> small
#=> medium
#=> large

header_contents
#=> client name
#=> company name
#=> project code, title, revision & status
#=> company logo/client logo

header_style
#=> left justified
#=> right justified
#=> center justified

footer_contents
#=> company name
#=> company details
#=> published date
#=> project code, title, revision & status
#=> company logo/client logo

footer_style
#=> left justified
#=> right justified
#=> center justified

page_numbers
#=> number only
#=> number & total

cover_options
#=> client name
#=> company name
#=> project code, title, revision & status
#=> company logo/client logo
#=> company details
#=> published date
#=> project image

cover_style
#=> left justified
#=> right justified
#=> center justified

cover_image
#=> justification
#=> inclusion
#=> location
#=> size



##OPTION 1a
#contents - no page numbers
#cover for each section
#section cover/no cover
#revisions - start on new sheet
#specification - start on new sheet
#page number by section

#OPTION 1b
#contents - with page numbers
#cover for each section
#section cover/no cover
#revisions - start on new sheet
#specification - start on new sheet
#page number for whole document

contents page

#preliminary sections
  if cover
    cover
      #section title
      #quality check boxes
      #list of revisions
  end
  
  #revisions
  if cover      
    revisions_page_one_style_1
        #title - revisions for section revision
        #
        
  else
    revisions_page_one_style_2
        #section_title
        #revisions title
        #revision number
        #line/space
  end
  sections.each do |section|
    revision_section_intro
    revisions.each do |revision|
      revisions_follow_on
    end  
  end

  #specifications
  if cover  
    specifications_page_one_style_1
        #title - lines for section revision
  else
    specifications_page_one_style_3
        #section_title
        #line/space
  end 

  sections.each do |section|
    specification_section_intro
    specifications.each do |specification|   
      specifications_follow_on
      #specifications - draft first 
  end  
end


#standard sections
sections.each do |section|
  if cover
    cover
      #section title
      #quality check boxes
      #list of revisions
  end    
    
  revisions.each do |revision|
    if cover      
      revisions_page_one_style_1
        #title - revisions for section revision
    else
      revisions_page_one_style_2
        #section_title
        #revisions title
        #revision number
        #line/space
    end
    revisions_follow_on
      #revisions - clause/line level - draft first
  end

  specifications.each do |specification|
    if cover  
      specifications_page_one_style_1
        #title - lines for section revision
    else
      specifications_page_one_style_2
        #section_title
        #line/space
    end    
    specifications_follow_on
      #specifications - draft first 
  end  
end




#OPTION 2a
#contents - no page numbers
#revisions at front of document
#section cover/no cover
#each section starts on new page
#page number by section


#OPTION 2b
#contents - no page numbers
#revisions at front of document
#section cover/no cover
#each section starts on new page
#page number by section

contents page

revisions_page_one_style_3
  sections.each do |section|
    revision_section_intro
    revisions.each do |revision|
      revisions_follow
    end  
  end

sections.each do |section|
  if cover
    cover
    specifications.each do |specification|
      specifications_page_one_style_1
      specifications_follow_on
    end
  else
    specifications.each do |specification|
      specifications_page_one_style_3
      specifications_follow_on
    end
  end  
end

#elements repeated on each page
#footer

#header

#watermark

#page numbers


