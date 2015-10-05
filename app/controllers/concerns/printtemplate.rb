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
  include Printuserlist

def print_document(project, revision, issue, pdf)

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
  pdf.text "[blank page]", :size => 10
  pdf.start_new_page

##USER LIST PAGE
  if issue == "audit"
    page_userlist(project, pdf)
    pdf.start_new_page
    pdf.text "[blank page]", :size => 10
    pdf.start_new_page
  end

##HEADER START POINT
  header_page_start = pdf.page_number

##CONTENTS - contents page printed last
#!!!!!!!!!!need to do dummy run to see if all the contents will fit on one page
  draft_content_page_count(project, revision, settings, pdf)

##DOCUMENT LEVEL PAGE NUMBERING START
  document_page_start = pdf.page_number

##REVISIONS
# print revisions - if reported at front of document  
#  if settings.structure == "group revisions"

#changed_subections = Cawssubsection.all_subsection_revisions(project, revision)
    #changed_sections = Alteration.changed_caws_all_sections(project, revision)
    changed_sections = @subsection_model.all_subsection_revisions(project, revision)
    if !changed_sections.blank?

        ##page nummber record
        document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]

        #cover page
       # if settings.section_cover == "section cover"
       #   revision_cover(pdf) 
       #   pdf.start_new_page
       #   pdf.y = 268.mm
       # else
          section_cover_style = {:size => 14, :style => :bold}
          pdf.move_down(8.mm) 
          pdf.spec_box "Document Revisions", section_cover_style.merge(:at =>[0.mm, pdf.y])
          pdf.move_down(pdf.box_height)
          pdf.move_down(8.mm)
       # end

        #state if product status has changed
        project_status_change(@previous_status, @current_status, pdf) if @status_change

        section_revisions(project, revision, issue, pdf)

        pdf.start_new_page
     end
#  else
#      if @status_change

        ##page nummber record
#        document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]

        #cover page
#        if settings.section_cover == "section cover"
#          revision_cover(pdf)
#          pdf.start_new_page
#          pdf.y = 268.mm
#        else
#          section_cover_style = {:size => 14, :style => :bold}
#          pdf.move_down(8.mm) 
#          pdf.spec_box "Document Revisions", section_cover_style.merge(:at =>[0.mm, pdf.y])
#          pdf.move_down(pdf.box_height)
#          pdf.move_down(8.mm)
#        end

        #state if product status has changed
#        project_status_change(@previous_status, @current_status, pdf)

#        pdf.start_new_page
#    end
#  end

## SUBSECTIONS
  subsections = @subsection_model.all_subsections(project)
  unless subsections.blank?
    subsections.each do |subsection|
  ##page nummber record
      document_content << [subsection.full_code_and_title, (pdf.page_number - document_page_start + 1)]

        #cover for combined prelim section
        if settings.section_cover == "section cover"
          section_cover(subsection, pdf)
          pdf.start_new_page 
        end

#        if settings.structure == "revision by section"
#          #revisions for project
#          subsection_revs = Alteration.changed_caws_subsections(project, revision, subsection)
#          if !subsection_revs.blank?
#              #set title based on whether cover is provided to section
#              caws_title_type(settings, subsection, "revision", pdf)
#              revisions_text(project, subsection, revision, pdf)
#
#              pdf.start_new_page
#          end
#        end

        #set title based on whether cover is provided to section
        caws_title_type(settings, subsection, "specification", pdf)
        #specline info
        #caws_title(subsection, "specline", pdf)
        specification(project, subsection, revision, issue, pdf)
#        specification(project, subsection, revision, user_array, print_audit, pdf)

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
  watermark_helper(project, revision, issue, pdf)

##PAGE NUMBERING
  page_numbers(document_page_start, document_page_end, settings, pdf)

##CONTENTS PAGE
  contents_page(document_content, pdf)

#subsection_pages[i][:subsection] = subsection.full_code_and_title
#subsection_pages[i][:number] = pdf.page_number

##DOCUMENT OUTLINE
#  outline(subsection_pages, pdf)


end


  def status_change(project)

    current_revision = Revision.where(:project_id => project.id).last
    previous_states = Revision.where(:project_id => project.id).pluck(:project_status)
    @previous_status = previous_states[previous_states.length - 2]
    @current_status = current_revision.project_status

    @status_changed = true if @current_status != @previous_status
  end


end