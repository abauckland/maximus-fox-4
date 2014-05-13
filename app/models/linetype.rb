class Linetype < ActiveRecord::Base
  #associations
has_many :speclines
has_many :alterations
has_many :lineclausetypes
end
