class Guidepdf < ActiveRecord::Base
  
  mount_uploader :guide, GuideUploader 
  
end