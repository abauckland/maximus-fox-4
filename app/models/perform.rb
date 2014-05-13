class Perform < ActiveRecord::Base
#associations    
  has_many :charcs
  has_many :instances, :through => :charcs

  has_many :speclines
  has_many :alterations
  
  belongs_to :performkey
  belongs_to :performvalue
end
