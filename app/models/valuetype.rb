class Valuetype < ActiveRecord::Base
    #associations  
    has_many :performvalues
    
    belongs_to :unit
    belongs_to :standard

  def perform_text
    performtxt.text unless performtxt_id == nil
  end

  def unit_text
    unless unit_id == nil
      unit.text
    else
      ""
    end
  end

  def standard_ref
    unless standard_id == nil
      standard.ref
    else
      ""
    end
  end

  def to_standard_ref
    unless standard_id == nil
      ' to '+standard.ref
    else
      ""
    end
  end

end
