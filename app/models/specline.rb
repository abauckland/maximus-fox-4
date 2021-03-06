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

#used
  scope :show_subsection_speclines, ->(project_id, subsection_id, clausetype_id, subsection_name) { 
                                        includes(:txt1, :txt3, :txt4, :txt5, :txt6, :identity => [:identkey, :identvalue], :perform => [:performvalue, :performkey], :clause => [:clausetitle, :guidenote, :clauseref => [:subsection]]
                                      ).where(:project_id => project_id, 'subsections.'+subsection_name+'_id' => subsection_id, 'clauserefs.clausetype_id' => clausetype_id
                                      ).order('clauserefs.clause_no, clauserefs.subclause, clause_line'
                                      )}

  scope :subsection_speclines, ->(project_id, subsection_ids, subsection_name) { 
                                      joins(:clause => [:clauseref => :subsection]
                                     ).where(:project_id => project_id, 'subsections.'+subsection_name+'_id' => subsection_ids
                                     ).order('clauserefs.clause_no, clauserefs.subclause, clause_line'
                                     )}


#not used
#  scope :product_identity_pairs, ->(specline) { joins(:identity => [:identvalue => :identtxt]
#                                   ).where(:project_id => specline.project_id, :clause_id => specline.clause_id, :linetype_id => 10,
#                                   ).where.not('identtxts.text' => "Not specified"
#                                   ).where.not(:id => specline.id
#                                   ).pluck('speclines.identity_id'
#                                   )}

#  scope :product_perform_pairs, ->(specline) { joins(:perform => [:performvalue => :performtxt]
#                                   ).where(:project_id => specline.project_id, :clause_id => specline.clause_id, :linetype_id => 11,
#                                   ).where.not('performtxts.text' => "Not specified"
#                                   ).where.not(:id => specline.id
#                                   ).pluck('speclines.perform_id'
#                                   )}

end
