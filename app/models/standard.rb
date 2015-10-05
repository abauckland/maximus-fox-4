class Standard < ActiveRecord::Base
  has_many :valuetypes

  def ref_and_title
    ref+' '+title
  end
end
