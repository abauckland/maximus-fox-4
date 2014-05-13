class Identity < ActiveRecord::Base
  #associations  
  has_many :descripts
  has_many :products, :through => :descripts

  has_many :speclines
  has_many :alteravtions
      
  belongs_to :identvalue
  belongs_to :identkey
end
