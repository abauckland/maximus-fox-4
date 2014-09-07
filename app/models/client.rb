class Client < ActiveRecord::Base

  belongs_to :projects
  
  mount_uploader :client_logo, ClientLogoUploader

end
