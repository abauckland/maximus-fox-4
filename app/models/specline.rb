class Specline < ActiveRecord::Base
  #associations
  belongs_to :project
  belongs_to :clause

  has_many :alterations

  belongs_to :txt1
  belongs_to :txt2
  belongs_to :txt3
  belongs_to :txt4
  belongs_to :txt5
  belongs_to :txt6

  belongs_to :identity
  belongs_to :perform

  belongs_to :linetype
  
  
  scope :cawssubsection_speclines, ->(project_id, cawssubsection_ids) { joins(:clause => [:clauseref => :subsection]
                                     ).where(:project_id => project_id, 'subsections.cawssubsection_id' => cawssubsection_ids
                                     )}

  scope :unisubsection_speclines, ->(project_id, unisubsection_ids) { joins(:clause => [:clauseref => :subsection]
                                    ).where(:project_id => project_id, 'subsections.unisubsection_id' => cawssubsection_ids
                                    )}

  scope :show_cawssubsection_speclines, ->(project_id, cawssubsection_id, clausetype_id) { includes(:txt1, :txt3, :txt4, :txt5, :txt6, :identity => [:identkey, :identvalue], :perform => [:performkey, :performvalue], :clause => [:clausetitle, :guidenote, :clauseref => [:subsection]]
                                        ).where(:project_id => project_id, 'subsections.cawssubsection_id' => cawssubsection_id, 'clauserefs.clausetype_id' => clausetype_id
                                        ).order('clauserefs.clause_no, clauserefs.subclause, clause_line')} 


#  scope :cawssubsection_speclines, ->(project_id, cawssubsection_id) { joins(:clause => [:clauserefs => :subsections]
 #                                         ).where(:project_id => project_id, 'subsections.cawssubsection_id' => cawssubsection_id
 #                                         )}

  scope :product_identity_pairs, ->(specline) { joins(:identity => [:identvalue => :identtxt]
                                   ).where(:project_id => specline.project_id, :clause_id => specline.clause_id, :linetype_id => 10,
                                   ).where.not('identtxts.text' => "Not specified"
                                   ).where.not(:id => specline.id
                                   ).pluck('speclines.identity_id'
                                   )}

  scope :product_perform_pairs, ->(specline) { joins(:perform => [:performvalue => :performtxt]
                                   ).where(:project_id => specline.project_id, :clause_id => specline.clause_id, :linetype_id => 11,
                                   ).where.not('performtxts.text' => "Not specified"
                                   ).where.not(:id => specline.id
                                   ).pluck('speclines.perform_id'
                                   )}
  
end
