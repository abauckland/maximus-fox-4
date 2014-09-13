module Printcover

def cover(project, revision, settings, pdf)

  if settings.client_logo != "none"  
    client_logo(project, settings, pdf)
  end
    
  if settings.client_detail != "none"  
    client_details(project, settings, pdf)
  end
    
  if settings.project_detail != "none"  
    project_details(project, revision, settings, pdf)
  end

  if settings.project_image != "none"  
    project_image(project, settings, pdf)
  end

  
  if settings.company_detail != "none"   
    company_details(project, settings, pdf)
  end   
   
end
 
def client_logo(project, settings, pdf)
  if !project.client_logo.blank?
      pdf.image project.client_logo.path, :position => settings.client_logo.to_sym, :vposition => 5.mm, :fit => [250,35]
  end 
end

def client_details(project, settings, pdf)
#font styles for page   
  client_style = {:size => 16, :align => settings.client_detail.to_sym}

  if !project.client_name.blank?
    pdf.bounding_box([0,250.mm], :width => 176.mm, :height => 50.mm) do       
      pdf.text "#{project.client_name}", client_style        
    end
  end   
end


def project_details(project, revision, settings, pdf)
#font styles for page  
  project_title_style = {:size => 18, :style => :bold, :align => settings.project_detail.to_sym}
  project_style = {:size => 14, :align => settings.project_detail.to_sym}
  
  if revision.rev.nil?
    current_revision_rev = 'n/a'
  else
    current_revision_rev = revision.rev.capitalize    
  end
 
  pdf.bounding_box([0, 220.mm], :width => 176.mm, :height => 30.mm) do
    pdf.text project.code_and_title, project_title_style
    pdf.text "Architectural Specification", project_style
    pdf.text "Issue: #{project.project_status}", project_style
    pdf.text "Revision: #{current_revision_rev}", project_style
  end
end


def project_image(project, settings, pdf)
  if !project.project_image.blank?
      pdf.image project.project_image.path, :position => settings.project_image.to_sym, :vposition => 100.mm, :fit => [350,250]
  end
end


def company_details(project, settings, pdf)
#find project company
    company = Company.joins(:users => :projectusers).where('projectusers.project_id' => project.id).first
  
    company_style = {:size => 9, :align => settings.company_detail.to_sym} 
  
    if !company.logo.blank?
      pdf.image company.logo.path, :position => settings.company_detail.to_sym, :vposition => 240.mm, :fit => [250,35]
    end
  
    pdf.bounding_box([0,17.mm], :width => 176.mm, :height => 400) do
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