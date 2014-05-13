class Standard < ActiveRecord::Base
has_many :valuetypes
has_many :standardsubsections

  def ref_and_title
    return ref+' '+title
  end
end
