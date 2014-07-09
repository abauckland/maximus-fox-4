class Client < ActiveRecord::Base

  belongs_to :project
  
  mount_uploader :client_logo, ClientLogoUploader

end
