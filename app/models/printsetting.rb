class Printsetting < ActiveRecord::Base
#associations
  belongs_to :project
  
  #document settings
  enum font_style: [:times_new_roman, :helvetica]
  enum font_size: [:small, :medium, :large]
  
  enum structure: [:group_revisions, :revision_by_section]
  enum prelim: [:single_section, :separate_sections]
  enum page_number: [:by_section, :by_document]
  
  enum section_cover: [:section_cover, :no_cover]
  
  
  #docuemnt cover
#  enum client_detail: [:do_not_show, :left, :centre, :right]
#  enum client_logo: [:do_not_show, :left, :centre, :right]
#  enum project_detail: [:do_not_show, :left, :centre, :right]
#  enum project_image: [:do_not_show, :left, :centre, :right]
#  enum company_detail: [:do_not_show, :left, :centre, :right]
  
  #header settings
#  enum header_project: [:do_not_show, :show]
#  enum header_client: [:do_not_show, :show]
#  enum header_document: [:do_not_show, :show]
#  enum header_logo: [:do_not_show, :author, :client]
  
  #footer settings
#  enum footer_detail: [:do_not_show, :show]
#  enum footer_author: [:do_not_show, :show]
#  enum footer_date: [:do_not_show, :show]

after_initiation :set_default_values

def set_default_values
  if new_record?
    self.font_style ||= 1
    self.font_size ||= 2
    
    self.structure ||= 2
    self.prelim ||= 2
    self.page_number ||= 2
    
    self.section_cover ||= 1
        
    self.client_detail ||= "right"   
    self.client_logo ||= "right" 
    self.project_detail ||= "right" 
    self.project_image ||= "right"     
    self.company_detail ||= "right" 
    
    self.header_project ||= true
    self.header_client ||= true   
    self.header_document ||= true
    self.header_logo ||= "do_not_show"
    
    self.footer_detail ||= true    
    self.footer_author ||= true
    self.footer_date ||= true
  end
end



end
