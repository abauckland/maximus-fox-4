class Print < ActiveRecord::Base
#sssociations
  belongs_to :project
  belongs_to :revision
  belongs_to :user
  
#  mount_uploader :issued, IssuedUploader

  #Paperclip will also throw "Missing Required Validator Error" in case of PDF file upload. The workaround for that is: First install the "GhostScript" and then add "application/pdf" to content-type.
  
  
  
end
