class Valuetype < ActiveRecord::Base
    #associations  
    has_many :performvalues
    
    belongs_to :unit
    belongs_to :standard
end
