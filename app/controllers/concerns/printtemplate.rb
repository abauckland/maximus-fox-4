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
  pdf.font "Times-Roman"#settings.font_style

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
  project_revisions = Alteration.changed_caws_all_sections(project, revision)
  if !project_revisions.blank?
    # print revisions - if reported at front of document  
    if settings.structure == "group revisions"

##page nummber record
    document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]

    #cover page
    revision_cover(pdf)
    pdf.start_new_page   
   
      #state if product status has changed
      if @status_change
        project_status_change(@previous_status, @current_status, pdf)
      end
  
      if settings.prelim == "single section" 
          prelim_subsections = Alteration.changed_caws_prelim_sections(project, revision)    
          if prelim_subsections
            
              revision_prelim_title(pdf)        
              prelim_sections.each do |subsection|
                  revision_prelim_subtitle(subsection, pdf)   
                  revisions_text(project, subsection, revision, pdf)
              end    
          end        
          subsections = Alteration.changed_caws_sections(project, revision)    
          if subsections
            revision_title_text(project, subsections, revision, pdf)  
          end        
      else
          subsections = Alteration.changed_caws_all_sections(project, revision)    
          if subsections
            revision_title_text(project, subsections, revision, pdf)   
          end
      end   
      pdf.start_new_page
    end      
  else      
    if @status_change            
      document_content << ["Document Revisions", (pdf.page_number - document_page_start + 1)]  
      #cover page
      revision_cover(pdf)
      pdf.start_new_page

      project_status_change(@previous_status, @current_status, pdf)            
    
      pdf.start_new_page
    end    
  end
  
  ##PRELIMINARIES
  if settings.prelim == "single section"   
    prelim_subsections = Cawssubsection.prelim_subsections(project)

    if !prelim_subsections.blank?
##page nummber record
      document_content << ["A-- Preliminaries", (pdf.page_number - document_page_start + 1)]
  
      #cover for combined prelim section
      if settings.section_cover == "section cover"
        prelim_caws_cover(pdf)   
        pdf.start_new_page
      end
      
      #revisions for all prelims sections
      if settings.structure == "revision by section"
          #print revision for each prelim section
                    
          check_revs_exist = Alteration.changed_caws_prelim_sections(project, revision)
          if !check_revs_exist.blank?
            
            
            if settings.section_cover == "section cover" #if there is a cover for prelims            
               combined_prelim_caws_subtitle("revision", pdf)
            else #if there is no cover            
               combined_prelim_caws_title("revision", pdf)
            end                     
              section_cover_style = {:size => 12, :style => :bold}
            #print list of subsections that have been added
              added_subsections = Cawssubsection.prelim_subsection_revisions_added(project, revision)
              if !added_subsections.blank?
                subsection_action("added", pdf)
                added_subsections.each do |subsection|
                  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[4.mm, pdf.y])
                  pdf.move_down(pdf.box_height)
                end
              end
                            
              deleted_subsections = Cawssubsection.prelim_subsection_revisions_deleted(project, revision)
              if !deleted_subsections.blank?
                subsection_action("deleted", pdf)
                deleted_subsections.each do |subsection|
                  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[4.mm, pdf.y])
                  pdf.move_down(pdf.box_height)
                end
              end
               
              changed_subsections = Cawssubsection.prelim_subsection_revisions_changed(project, revision)
              if !changed_subsections.blank?
                subsection_action("changed", pdf)
                changed_subsections.each do |subsection|
                  pdf.spec_box subsection.full_code_and_title, section_cover_style.merge(:at =>[4.mm, pdf.y])
                  pdf.move_down(pdf.box_height)
                  
                  combined_revision_info(project, subsection, revision, pdf)
                  
                end
              end                                             
            pdf.start_new_page
          end  
      end
      #speclines for prelims
      if settings.section_cover == "section cover"
        combined_prelim_caws_subtitle("specification", pdf)
      else
        combined_prelim_caws_title("specification", pdf)
      end    
      #prelim_subsections = Cawssubsection.prelim_subsections(project)  
      prelim_subsections.each do |subsection|
        prelim_caws_title(subsection, "specification", pdf)    
        specification(project, subsection, revision, pdf)
      end
      pdf.start_new_page
    end
  else
  
    prelim_subsections = Cawssubsection.prelim_subsections(project)
    if !prelim_subsections.blank?
      prelim_subsections.each do |subsection|     
  ##page nummber record
      document_content << [subsection.full_code_and_title, (pdf.page_number - document_page_start + 1)]
  
          #cover for combined prelim section
          if settings.section_cover == "section cover"
            prelim_caws_cover(pdf)   
            pdf.start_new_page
          end      
                
          if settings.structure == "revision by section"
            #revisions for project
            subsection_revs = Alteration.changed_caws_subsections(project, revision, subsection)            
            if subsection_revs
                #set title based on whether cover is provided to section  
                prelim_caws_title_type(settings, subsection, "revision", pdf)    
                  revision_info(project, prelim_subsections, revision, pdf)            
                pdf.start_new_page        
            end  
          end
          #set title based on whether cover is provided to section      
          prelim_caws_title_type(settings, subsection_revs, "specification", pdf)   
          #specline info
          caws_specification_title(subsection, pdf)    
          caws_specification(project, subsection, revision, pdf)
          pdf.start_new_page    
      end
    end    
  end


##NON PRELIM SUBSECTIONS
  subsections = Cawssubsection.subsections(project)
  if !subsections.blank?
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
                revision_info(project, subsections, revision, pdf)
              pdf.start_new_page        
          end  
        end
        #set title based on whether cover is provided to section      
        caws_title_type(settings, subsection, "specification", pdf) 
        #specline info
        caws_specification_title(subsection, pdf)    
        caws_specification(project, subsection, revision, pdf)
        
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

    if @current_status != @previous_status
        @status_changed = true
    end
    
  end


#end of module
end










