class Alteration < ActiveRecord::Base
#associations
belongs_to :revision
belongs_to :project
belongs_to :specline
belongs_to :linetype
belongs_to :clause

belongs_to :txt1
belongs_to :txt2
belongs_to :txt3
belongs_to :txt4
belongs_to :txt5
belongs_to :txt6
belongs_to :identity
belongs_to :perform

belongs_to :user


  scope :changed_caws_subsections, ->(project, revision, subsection) { joins(:clause => [:clauseref => :subsection]
                                    ).where(:clause_add_delete => 3, :project_id => project.id, 'subsections.cawssubsection_id' => subsection.id, :revision_id => revision.id
                                    ).first }
  
  
end
