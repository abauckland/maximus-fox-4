class Instance < ActiveRecord::Base
  #associations
  has_many :charcs
  has_many :performs, :through => :chars
  belongs_to :product
end
