class Clauseguide < ActiveRecord::Base
  belongs_to :clause
  belongs_to :guidenote

  accepts_nested_attributes_for :guidenote

end
