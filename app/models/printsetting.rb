class Printsetting < ActiveRecord::Base
#associations
  belongs_to :project
  

before_create :set_default_values

def set_default_values
    self.font_style = "helvetica"
    self.font_size = "medium"

    self.structure = "revision by section"
    self.prelim = "separate sections"
    self.page_number = "by document"

    self.section_cover = "no cover"

    self.client_detail = "right"
    self.client_logo = "right" 
    self.project_detail = "right" 
    self.project_image = "right"
    self.company_detail = "right" 

    self.header_project = "show"
    self.header_client = "show"  
    self.header_document = "show"
    self.header_logo = "none"

    self.footer_detail = "show"
    self.footer_author = "show"
    self.footer_date = "show"

end



end
