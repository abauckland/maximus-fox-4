class Descript < ActiveRecord::Base
  #associations 
  belongs_to :product
  belongs_to :identity
end
