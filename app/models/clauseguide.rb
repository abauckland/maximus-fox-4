class Clauseguide < ActiveRecord::Base
  belongs_to :clause
  belongs_to :guidenote

  accepts_nested_attributes_for :guidenote

  def clause_title
    clause.clauseref_code + ' ' + clause.clause_title
  end

end
