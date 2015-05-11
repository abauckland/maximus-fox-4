class Unisection < ActiveRecord::Base
    has_many :unisubsections

  scope :project_sections, ->(project) { joins(:unisubsections => [:subsections => [:clauserefs => [:clauses => :speclines]]]
                                       ).where('speclines.project_id' => project.id
                                       ).group(:id).sort
                                       }

  def code_and_title
   ref.to_s+' '+text.to_s
  end

end
