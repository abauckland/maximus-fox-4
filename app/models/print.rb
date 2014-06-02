class Print < ActiveRecord::Base
#sssociations
  belongs_to :project
  belongs_to :revision
  belongs_to :user
  
  has_attached_file :attachment
  
end
