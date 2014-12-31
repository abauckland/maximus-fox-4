module Printtemplate

  include Printcover
  include Printcontent
  include Printheader
  include Printfooter
  include Printrevision
  include Printspecline
  include Printwatermark
  include Printsubtitle  
  include Printoutline
  include Printnumbers

def print_caws_document(project, revision, pdf)

  settings = Printsetting.where(:project_id => project.id).first
  #array for storing content page numbers
  document_content = []

  #check if status of project has changed
  status_change(project)
  
#set common document settings  
  pdf.font settings.font_style

##COVER
  cover(project, revision, settings, pdf)
  pdf.start_new_page
  
##BLANK PAGE  
  #leave page blank so that contents page starts of page 2 - allows replacement of cover when printing double sided 
  pdf.text "[blank page]", :size =>10    
  pdf.start_new_page


##HEADER START POINT
  header_page_start = pdf.page_number

##CONTENTS - contents page printed last
#!!!!!!!!!!need to do dummy run to see if all the contents will fit on one page  
  draft_content_page_count(project, revision, settings, pdf)

##DOCUMENT LEVEL PAGE NUMBERING START
  document_page_start = pdf.page_number

##REVISIONS
# print revisions - if reported at front of document  
  if settings.structure == "revisions by document"
  
#changed_subections = Cawssubsection.all_subsection_revisions(project, revision)
    #changed_sections = Alteration.changed_caws_all_sections(project, revision)
    changed_sections = Cawssubsection.all_subsection_revisions(project, revision)
    if !changed_sections.blank?
  
        ##page nummber record
        document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]
    
        #cover page
        if settings.section_cover == "section cover"
          revision_cover(pdf)       
          pdf.start_new_page
          pdf.y = 268.mm
        end
        #state if product status has changed        
        project_status_change(@previous_status, @current_status, pdf) if @status_change

        changed_sections.each do |subsection|
          combined_revisions_text(project, subsection, revision, pdf)
        end

        pdf.start_new_page
      end
    else
      if @status_change

        ##page nummber record      
        document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]

        #cover page
        if settings.section_cover == "section cover"
          revision_cover(pdf)       
          pdf.start_new_page
          pdf.y = 268.mm   
        end

        #state if product status has changed
        project_status_change(@previous_status, @current_status, pdf)

        pdf.start_new_page
    end    
  end

## SUBSECTIONS
  subsections = Cawssubsection.all_subsections(project)
  unless subsections.blank?
    subsections.each do |subsection|     
  ##page nummber record
      document_content << [subsection.full_code_and_title, (pdf.page_number - document_page_start + 1)]

        #cover for combined prelim section
        if settings.section_cover == "section cover"
          section_cover(subsection, pdf)
          pdf.start_new_page 
        end

        if settings.structure == "revision by section"
          #revisions for project
          subsection_revs = Alteration.changed_caws_subsections(project, revision, subsection)
          if subsection_revs
              #set title based on whether cover is provided to section
              caws_title_type(settings, subsection, "revision", pdf)
              revisions_text(project, subsection, revision, pdf)

              pdf.start_new_page
          end  
        end

        #set title based on whether cover is provided to section   
        caws_title_type(settings, subsection, "specification", pdf)
        #specline info
        #caws_title(subsection, "specline", pdf)
        specification(project, subsection, revision, pdf)

        pdf.start_new_page
    end    
  end
  #always one last blank page based on starting new page at end of each loop
  pdf.move_down(10)
  pdf.text "[blank page]", :size =>10
  
  header_page_end = pdf.page_number
  document_page_end = pdf.page_number

##HEADERS
  header(project, settings, header_page_start, header_page_end, pdf) 

##FOOTERS
  footer(project, revision, settings, header_page_start, header_page_end, pdf)  

#WATERMARKS
  watermark_helper(project, revision, pdf)

##PAGE NUMBERING
  page_numbers(document_page_start, document_page_end, settings, pdf)

##CONTENTS PAGE
  contents_page(document_content, pdf)

#subsection_pages[i][:subsection] = subsection.full_code_and_title
#subsection_pages[i][:number] = pdf.page_number

##DOCUMENT OUTLINE
#  outline(subsection_pages, pdf)


end

  def combined_revision_info(project, subsection, revision, pdf)
   # subsections.each do |subsection|
  #    combined_revision_title(subsection, pdf)   
      combined_revisions_text(project, subsection, revision, pdf)
  #  end 
  end




  def revision_info(project, subsection, revision, pdf)
   # subsections.each do |subsection|
    #  revision_title(subsection, pdf)   
      revisions_text(project, subsection, revision, pdf)
  #  end 
  end


  def status_change(project)
    
    current_revision = Revision.where(:project_id => project.id).last
    previous_states = Revision.where(:project_id => project.id).pluck(:project_status)
    @previous_status = previous_states[previous_states.length - 2]
    @current_status = current_revision.project_status
    
    @status_changed = true if @current_status != @previous_status    
  end

#end of module
end










