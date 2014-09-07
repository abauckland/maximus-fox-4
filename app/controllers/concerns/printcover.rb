module Printcover

def cover(project, revision, settings, pdf)

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
 

def client_details(project, settings, pdf)
#font styles for page   
  client_style = {:size => 16, :style => :bold, :align => settings.company_detail.to_sym}

  if !project.client_name.blank?
    pdf.bounding_box([0,273.mm], :width => 176.mm, :height => 400) do    
      if !project.client_logo.blank?
        pdf.image project.client_logo, :position => :right, :vposition => :logo_bottom, :fit => [350,250]
      end    
      pdf.text "#{project.client_name}", client_style        
    end
  end   
end


def project_details(project, revision, settings, pdf)
#font styles for page  
  project_title_style = {:size => 18, :style => :bold, :align => settings.company_detail.to_sym}
  project_style = {:size => 14}
  
  if revision.rev.nil?
    current_revision_rev = 'n/a'
  else
    current_revision_rev = revision.rev.capitalize    
  end
  
  
  pdf.bounding_box([0, 240.mm], :width => 176.mm, :height => 400) do
    pdf.text project.code_and_title, project_title_style.merge(:align => :left)
    pdf.text "Architectural Specification", project_style.merge(:align => :left)
    pdf.text "Issue: #{project.project_status}", project_style.merge(:align => :left)
    pdf.text "Revision: #{current_revision_rev}", project_style.merge(:align => :left)
  end
end

 
def project_image(project, settings, pdf) 

  if !project.project_image.blank?
    pdf.image project.project_image.path, :position => :right, :vposition => :logo_bottom, :fit => [350,250]
  end
  
end



def company_details(project, settings, pdf)
#find project company
  company = Company.joins(:users => :projectusers).where('projectusers.project_id' => project.id).first

  company_style = {:size => 9, :align => settings.company_detail.to_sym} 

  if !company.logo.blank?
    pdf.image company.logo.path, :position => :right, :vposition => -0.mm, :fit => [250,35]
  end
  
    pdf.bounding_box([0,35 + 3.mm], :width => 176.mm, :height => 400) do
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