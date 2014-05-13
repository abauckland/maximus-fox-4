class Cawssection < ActiveRecord::Base
  has_many :cawssubsections

  def code_and_title
   ref.to_s+' '+text.to_s
  end
end
