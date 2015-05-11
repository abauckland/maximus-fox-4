class Unisubsection < ActiveRecord::Base
  belongs_to :unisection
  has_many :subsections


  scope :project_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                           ).where('speclines.project_id' => project.id
                                           ).group('unisubsections.id'
                                           ).order('unisubsections.id'
                                           )} 


  scope :template_subsections, ->(project, template) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                                      ).where('speclines.project_id' => template.id
                                                      ).group('unisubsections.id'
                                                      ).order('unisubsections.id'
                                                      )}


  scope :all_subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => project.id
                                         ).group('unisubsections.id'
                                         ).order('unisubsections.id'
                                         )}


  scope :subsections, ->(project) { joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                         ).where('speclines.project_id' => project.id
                                         ).where.not(:unisection_id => 1
                                         ).group('unisubsections.id'
                                         ).order('unisubsections.id'
                                         )}


  scope :all_subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
                                         ).group('unisubsections.id'
                                         )}


  scope :subsection_revisions, ->(project, revision) { joins(:subsections => [:clauserefs => [:clauses => :alterations]]
                                         ).where('alterations.project_id' => project.id, 'alterations.revision_id' => revision.id
                                         ).where.not(:unisection_id => 1
                                         ).group('unisubsections.id'
                                         )}


  scope :section_subsections, ->(project, section) {joins(:subsections => [:clauserefs => [:clauses => :speclines]]
                                   ).includes(:unisection).where('speclines.project_id' => project.id, :unisection_id => section.id
                                   ).group('unisubsections.id').sort 
                                   }


  def full_code
    return unisection.ref.to_s + sprintf("%02d", ref).to_s
  end

  def full_code_and_title
    return unisection.ref.to_s + sprintf("%02d", ref).to_s+' '+text.to_s
  end

  def part_code_and_title
    return sprintf("%02d", ref).to_s+' '+text.to_s
  end


end
