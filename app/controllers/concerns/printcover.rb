module Printcover

def cover(project, revision, settings, pdf)

  if settings.client_detail != "do not show" 
    client_details(project, settings, pdf)
  end
    
  if setting.project_detail != "do not show" 
    poject_details(project, revision, settings, pdf)
  end

  if settings.project_image != "do not show"   
    project_image(project, settings, pdf)
  end
  
  if settings.company_detaile != "do not show"   
    company_details(project, settings, pdf)
  end   
   
end
 

def client_details(project, settings, pdf)
#font styles for page   
  client_style = {:size => 16, :style => :bold, :align => :right}

  pdf.bounding_box([0,35 + 9.mm], :width => 176.mm, :height => 400) do
    if !current_project.photo_file_name.blank?
      pdf.image "#{Rails.root}/public#{current_project.photo.url.sub!(/\?.+\Z/, '') }", :position => :right, :vposition => :logo_bottom, :fit => [350,250]
    end
    pdf.text "#{project.client}", client_style        
  end   
end


def poject_details(project, revision, settings, pdf)
#font styles for page  
  project_title_style = {:size => 18, :style => :bold}
  project_style = {:size => 16}
  
  if revisions.rev.nil?
    current_revision_rev = 'n/a'
  else
    current_revision_rev = revision.rev.capitalize    
  end
  
  
  pdf.bounding_box([0,35 + 9.mm], :width => 176.mm, :height => 400) do
    pdf.text "#{project.code} #{project.title}", project_title_style.merge(:align => settings.project_detail)
    pdf.text "Architectural Specification", project_style.merge(:align => settings.project_detail)
    pdf.text "Issue: #{project.project_status}", project_style.merge(:align => settings.project_detail)
    pdf.text "Revision: #{current_revision_rev}", project_style.merge(:align => settings.project_detail)
  end
end

 
def project_image(project, settings, pdf) 

  if !current_project.photo_file_name.blank?
    pdf.image "#{Rails.root}/public#{current_project.photo.url.sub!(/\?.+\Z/, '') }", :position => :right, :vposition => :logo_bottom, :fit => [350,250]
  end
  
end



def company_details(project, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.role' => "owner", 'projectusers.project_id' => project.id).first

  company_style = {:size => 8, :align => :left} 

  if !company.photo_file_name.blank?
    pdf.image "#{Rails.root}/public#{company.photo.url.sub!(/\?.+\Z/, '') }", :position => :right, :vposition => -0.mm, :fit => [250,35]
  end
  
    pdf.bounding_box([0,35 + 9.mm], :width => 176.mm, :height => 400) do
      if !company.reg_name.blank?
        pdf.text company.reg_name, company_style
      end
      if !company.reg_location.blank?
        pdf.text "Registered in #{company.reg_location} No: #{company.reg_number}", company_style
      end
      if !company.reg_address.blank?
        pdf.text company.reg_address, company_style
      end
      if !company.tel.blank?
        pdf.text "#{company.www} Tel: #{company.tel}", company_style
      end
    end
end


end