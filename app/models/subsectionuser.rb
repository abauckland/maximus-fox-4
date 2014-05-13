class Subsectionuser < ActiveRecord::Base
  belongs_to :projectuser
  belongs_to :subsection
      
end
