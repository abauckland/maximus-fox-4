class Printsetting < ActiveRecord::Base
#associations
  belongs_to :project
  

#after_initiation :set_default_values

def set_default_values
  if new_record?
    self.font_style ||= "helvetica"
    self.font_size ||= "medium"
    
    self.structure ||= "revision by section"
    self.prelim ||= "separate sections"
    self.page_number ||= "by document"
    
    self.section_cover ||= "section cover"
        
    self.client_detail ||= "right"   
    self.client_logo ||= "right" 
    self.project_detail ||= "right" 
    self.project_image ||= "right"     
    self.company_detail ||= "right" 
    
    self.header_project ||= "show"
    self.header_client ||= "show"  
    self.header_document ||= "show"
    self.header_logo ||= "do_not_show"
    
    self.footer_detail ||= "show"   
    self.footer_author ||= "show"
    self.footer_date ||= "show"
  end
end



end
