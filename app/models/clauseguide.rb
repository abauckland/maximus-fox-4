class Clauseguide < ActiveRecord::Base
  belongs_to :clause
  belongs_to :guidenote

  accepts_nested_attributes_for :guidenote

  scope :project_guides, ->(project, subsection_id, subsection_name) {
                            joins(:clause => [:speclines, :clauseref => [:subsection]]
                          ).where('subsections.'+subsection_name+'_id' => subsection_id, 'speclines.project_id' => project.id
                          ).uniq.order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                          )}

  def clause_title
    clause.clauseref_code + ' ' + clause.clause_title
  end

end
