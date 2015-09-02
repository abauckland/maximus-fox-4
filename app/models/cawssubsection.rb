class Cawssubsection < ActiveRecord::Base
  belongs_to :cawssection
  has_many :subsections

#used
  scope :project_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                           ).where('speclines.project_id' => project.id
                                           ).group('cawssubsections.id'
                                           ).order('cawssubsections.id'
                                           )} 

#  scope :project_user_subsections, ->(project, current_user) { joins(:subsections => [:susbectionusers => [:projectusers], :clauserefs => [:clauses => :speclines]]
#                                           ).where('speclines.project_id' => project.id, 'projectusers.user_id' => current_user.id
#                                           ).group(:id
#                                           ).order(:id
#                                           )}                                             

#used
  scope :template_subsections, ->(project, template) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                                      ).where('speclines.project_id' => template.id
                                                      ).group('cawssubsections.id'
                                                      ).order('cawssubsections.id'
                                                      )}

#  scope :template_user_subsections, ->(project, template, current_user) { joins(:subsections => [:susbectionusers => [:projectusers], :clauserefs => [:clauses => :speclines]]
#                                                      ).where('speclines.project_id' => template.id, 'projectusers.user_id' => current_user.id
#                                                      ).where.not('speclines.project_id' => project.id
#                                                      ).group(:id
#                                                      ).order(:id
#                                                      )}

#  scope :filter_user, ->(current_user) { joins(:subsections => [:subsectionusers => :projectuser]
#                                                      ).where('projectusers.user_id' => current_user.id    
#                                                      )}


  scope :all_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => project.id
                                         ).group('cawssubsections.id'
                                         ).order('cawssubsections.id'
                                         )}


#  scope :prelim_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
#                                         ).where('speclines.project_id' => project.id
#                                         ).where(:cawssection_id => 1
#                                         ).group('cawssubsections.id'
#                                         ).order('cawssubsections.id'
#                                         )}

  scope :subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => project.id
                                         ).where.not(:cawssection_id => 1
                                         ).group('cawssubsections.id'
                                         ).order('cawssubsections.id'
                                         )}

#revisions view
  scope :all_subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
                                         ).group('cawssubsections.id'
                                         )}

#  scope :prelim_subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
#                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
#                                         ).where(:cawssection_id => 1
#                                         ).group('cawssubsections.id'
#                                         )}

#  scope :prelim_subsection_revisions_added, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
#                                         ).where('alterations.clause_add_delete' => 3, 'alterations.event' => 'new', 'alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
#                                         ).where(:cawssection_id => 1
#                                         ).group('cawssubsections.id'
#                                         )}

#  scope :prelim_subsection_revisions_deleted, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
#                                         ).where('alterations.clause_add_delete' => 3, 'alterations.event' => 'deleted', 'alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
#                                         ).where(:cawssection_id => 1
#                                         ).group('cawssubsections.id'
#                                         )}

#  scope :prelim_subsection_revisions_changed, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
#                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
#                                         ).where(:cawssection_id => 1
#                                         ).where.not('alterations.clause_add_delete' => 3                                         
#                                         ).group('cawssubsections.id'
#                                         )}


  scope :subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
                                         ).where.not(:cawssection_id => 1
                                         ).group('cawssubsections.id'
                                         )}


  scope :section_subsections, ->(project, section) {joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                   ).includes(:cawssection).where('speclines.project_id' => project.id, :cawssection_id => section.id
                                   ).group('cawssubsections.id').sort 
                                   }
                               
  def full_code
    return cawssection.ref.to_s + sprintf("%02d", ref).to_s
  end


  def full_code_and_title
    return cawssection.ref.to_s + sprintf("%02d", ref).to_s+' '+text.to_s
  end

  def part_code_and_title
    return sprintf("%02d", ref).to_s+' '+text.to_s
  end

end
