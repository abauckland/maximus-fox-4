class Lineclausetype < ActiveRecord::Base
  #associations
  belongs_to :clausetype
  belongs_to :linetype
end
