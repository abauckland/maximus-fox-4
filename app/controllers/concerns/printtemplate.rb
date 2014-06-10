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

def print_caws_document(project, revision, pdf)

  settings = Printsetting.where(:project_id => project.id).first

  #check if status of project has changed
  status_change(project)



  
#set common document settings  
  pdf.font settings.font_style


  

##COVER
  cover(project, revision, settings, pdf)

##CONTENTS - contents page printed last


##REVISIONS
  # print revisions - if reported at front of document  
  if settings.structure == "group revisions"
  #get all subsections for project with change

    #cover page
    revision_cover(pdf)
#PPPPPPP
    pdf.start_new_page

##COMPLETE!!!  
    #state if product status has changed
    if @status_change
      project_status_change(@previous_status, @current_status, pdf)
    end

    if settings.prelim == "single section" 
        prelim_subsections = Alteration.changed_caws_prelim_sections(project, revision)
    
        if prelim_subsections
          
            revision_prelim_title
        
            prelim_sections.each do |subsection|
                revision_prelim_subtitle(subsection, pdf)   
                revisions(project, subsection, revision, pdf)
            end    
        end
        
        subsections = Alteration.changed_caws_sections(project, revision)    
        if subsections
            subsections.each do |subsection|
                revision_title(subsection, pdf)   
                revisions(project, subsection, revision, pdf)
            end    
        end        
    else
        subsections = Alteration.changed_caws_all_sections(project, revision)    
        if subsections
            subsections.each do |subsection|
                revision_title(subsection, pdf)   
                revisions(project, subsection, revision, pdf)
            end    
        end
     end   
     pdf.start_new_page
  else  
    if @status_change
      
      #cover page
      revision_cover(pdf)
      pdf.start_new_page
      
      project_status_change(@previous_status, @current_status, pdf)
      
      pdf.start_new_page
    end    
  end


##PRELIMINARIES
if settings.prelim == "single section" 
  
  #cover for combined prelim section
  if settings.section_cover == "section cover"
    prelim_caws_cover(pdf)
#PPPPPPP    
    pdf.start_new_page
  end

  #revisions for all prelims sections
  if settings.structure == "revision by section"
      if settings.section_cover == "section cover"
          #if there is a cover for prelims
          prelim_caws_revision_subtitle(subsection, pdf)
      else
          #if there is no cover
          prelim_caws_revision_title(subsection, pdf)
      end 
    
      #print revision for each prelim section
      prelim_subsections = Alteration.changed_caws_prelim_sections(project, revision)
    
      prelim_subsections.each do |subsection|
          revision_title(subsection, pdf)   
          revisions(project, subsection, revision, pdf)
      end 
      pdf.start_new_page
  end

  #speclines for prelims
  if settings.section_cover == "section cover"
    #if there is a cover for prelims
    prelim_caws_specification_subtitle(subsection, pdf)
  else
    #if there is no cover
    prelim_caws_specification_title(subsection, pdf)
  end  
  
  prelim_subsections = Cawssubsection.prelim_subsections(project)
  
  prelim_subsections.each do |subsection|
    specification_title(subsection, pdf)    
    specification(project, subsection, revision, pdf)
  end
  pdf.start_new_page

else

  prelim_subsections = Cawssubsection.prelim_subsections(project)

  prelim_subsections.each do |subsection|
     
      #cover for combined prelim section
      if settings.section_cover == "section cover"
        prelim_caws_cover(pdf)
#PPPPPPP    
        pdf.start_new_page
      end      
            
      if structure.revision_by_section?
        #revisions for project
        subsection_revs = Alteration.changed_caws_subsections(project, revision, subsection)
            
        if subsection_revs
            if settings.section_cover == "section cover"
                #if there is a cover for prelims
                prelim_caws_revision_subtitle(subsection, pdf)
            else
                #if there is no cover
                prelim_caws_revision_title(subsection, pdf)
            end 
    
            subsection_revs.each do |subsection_rev|
                revision_title(subsection_rev, pdf)   
                revisions(project, subsection_rev, revision, pdf)
            end 
            pdf.start_new_page        
          end  
      end

      #speclines for prelims
      if settings.section_cover == "section cover"
          #if there is a cover for prelims
          prelim_caws_specification_subtitle(subsection, pdf)
      else
          #if there is no cover
          prelim_caws_specification_title(subsection, pdf)
      end  
  
      specification_title(subsection, pdf)    
      specification(project, subsection, revision, pdf)
  end
  pdf.start_new_page
end


##NON PRELIM SUBSECTIONS
  subsections = Cawssubsection.subsections(project)

  subsections.each do |subsection|
     
      #cover for combined prelim section
      if settings.section_cover == "section cover"
        prelim_caws_cover(pdf)
#PPPPPPP     
        pdf.start_new_page
      end      
            
      if settings.structure == "revision by section"
        #revisions for project
        subsection_revs = Alteration.changed_caws_subsections(project, revision, subsection)
            
        if subsection_revs
            if settings.section_cover == "section cover"
                #if there is a cover for prelims
                caws_revision_subtitle(subsection, pdf)
            else
                #if there is no cover
                caws_revision_title(subsection, pdf)
            end 
    
            subsection_revs.each do |subsection_rev|
                revision_title(subsection_rev, pdf)   
                revisions(project, subsection_rev, revision, pdf)
            end 
            pdf.start_new_page        
          end  
      end

      #speclines for prelims
      if settings.section_cover == "section cover"
          #if there is a cover for prelims
          caws_specification_subtitle(subsection, pdf)
      else
          #if there is no cover
          caws_specification_title(subsection, pdf)
      end  
  
      specification_title(subsection, pdf)    
      specification(project, subsection, revision, pdf)
  end
  pdf.start_new_page


##HEADERS
  header(project, settings, pdf) 

##FOOTERS
  footer(project, revision, settings, pdf)  

#WATERMARKS
  watermark_helper(project, revision, pdf)

##PAGE NUMBERING
#  page_numbers(subsection_pages, settings, pdf)

##CONTENTS PAGE
#  contents(subsection_pages, pdf)

##DOCUMENT OUTLINE
#  outline(subsection_pages, pdf)


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










