module PrintsettingsHelper

  def client_logo_exists(print_settings)
     project = Project.where(:id => print_settings.project_id).first
    unless project.client_logo?
      return {disabled: true}
    else
      return {disabled: false}
    end
  end


  def project_image_exists(print_settings)
     project = Project.where(:id => print_settings.project_id).first
    unless project.project_image?
      return {disabled: true}
    else
      return {disabled: false}
    end
  end


  def client_detail_exists(print_settings)
     project = Project.where(:id => print_settings.project_id).first
    unless project.client_name?
      return {disabled: true}
    else
      return {disabled: false}
    end
  end


  def company_logo_exists(print_settings)
    company = Company.joins(:projects).where('projects.id' => print_settings.project_id).first
    unless company.logo?
      return {disabled: true}
    else
      return {disabled: false}
    end
  end

end