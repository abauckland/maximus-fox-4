class Performvalue < ActiveRecord::Base
  #associations  
    has_many :performs
    belongs_to :performtxt
    belongs_to :valuetype


  def value_with_units
    performtxt.text + valuetype.unit_text + valuetype.to_standard_ref
  end

end
