class Subsecton < ActiveRecord::Base
  
  has_many :subsectionusers
  has_many :clauserefs
  
  belongs_to :cawssubsection
  belongs_to :unisubsection 
  
 

end
