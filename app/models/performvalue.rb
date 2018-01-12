class Performvalue < ActiveRecord::Base
  #associations  
    has_many :performs
    belongs_to :performtxt
    belongs_to :valuetype


  def retrieve_or_create(text)
    if text == ""
      existing_value = self.first
    else
      existing_value = Performvalue.where(:text => text).first
      if existing_value.blank?
         new_value = Performvalue.create(:text => text)
      else
         new_value = existing_value
      end
    end
  end


  def value_with_units
    performtxt.text + valuetype.unit_text + valuetype.to_standard_ref
  end

end
