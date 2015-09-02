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

#need to allow hash of specline to be saved into Alteration model - should really delete out of hasd before creating
attr_accessor :clause_line

#used
  scope :match_line, ->(line, revision) { where(:txt3_id => line.txt3_id,
                                                :txt4_id => line.txt4_id,
                                                :txt5_id => line.txt5_id,
                                                :txt6_id => line.txt6_id,
                                                :identity_id => line.identity_id,
                                                :perform_id => line.perform_id,
                                                :revision_id => revision.id,
                                                :project_id => line.project_id,
                                                :clause_id => line.clause_id,
                                                :linetype_id => line.linetype_id
                                                )}

#used
  scope :match_clause, ->(clause_id, project, revision) { where(:clause_id => clause_id,
                                                                :project_id => project,
                                                                :revision_id => revision
                                                                )}

#used
  scope :all_changes, ->(project, revision) { where(:project_id => project.id, :revision_id => revision.id
                                                 ).group(:id
                                                 ) }



  scope :changed_caws_all_sections, ->(project, revision) { where(:project_id => project.id, :revision_id => revision.id
                                    ).group(:id
                                    ) }

  scope :changed_caws_prelim_sections, ->(project, revision) { joins(:clause => [:clauseref => [:subsection => :cawssubsection]]
                                    ).where(:project_id => project.id, :revision_id => revision.id, 'cawssubsections.cawssection_id' => 1
                                    ).group(:id
                                    ) }

  scope :changed_caws_sections, ->(project, revision) { joins(:clause => [:clauseref => [:subsection => :cawssubsection]]
                                    ).where(:project_id => project.id, :revision_id => revision.id
                                    ).where.not('cawssubsections.cawssection_id' => 1
                                    ).group(:id
                                    ) }
  
  scope :changed_caws_subsections, ->(project, revision, subsection) { joins(:clause => [:clauseref => :subsection]
                                    ).where(:project_id => project.id, 'subsections.cawssubsection_id' => subsection.id, :revision_id => revision.id
                                    ).group(:id
                                    ) }
#  def self.changed_caws_subsections_show(project, revision, subsection) 
#    joins(:clause => [:clauseref => :subsection]
#   ).where(:clause_add_delete => 3, :project_id => project.id, 'subsections.cawssubsection_id' => subsection.id, :revision_id => revision.id
#   ).first 
#  end

  scope :changed_caws_subsections_show, ->(project, revision, subsection) { joins(:clause => [:clauseref => :subsection]
                                    ).where(:project_id => project.id, 'subsections.cawssubsection_id' => subsection.id, :revision_id => revision.id
                                    ).first
                                    }
  
end
