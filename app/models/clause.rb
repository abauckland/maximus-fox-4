class Clause < ActiveRecord::Base
#associations

has_many :projects, :through => :speclines
has_many :alterations
has_many :speclines

has_many :clauseproducts
has_many :products, :through => :clauseproducts

belongs_to :clauseref
belongs_to :clausetitle
belongs_to :guidenote

has_many :clauseguides

#has_many :associations
#has_many :associates, :through => :associations

accepts_nested_attributes_for :clauseref
accepts_nested_attributes_for :clausetitle

attr_accessor :title_text

before_validation :custom_validation_1
before_save :assign_title

#used
  scope :project_subsection, ->(project, subsection_id, subsection_name, current_user) { joins(:clauseref => [:subsection], :speclines => [:project => :projectusers]
                                  ).where('projectusers.user_id' => current_user.id
                                  ).where('speclines.project_id' => project.id
                                  ).where('subsections.'+subsection_name+'_id' => subsection_id
                                  ).group(:id
                                  ).order('clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                                  )}

#used
  scope :subsection_clauses, ->(project, subsection, subsection_name) { joins(:speclines
                        ).includes(:clausetitle, :clauseref => [:subsection]
                        ).where('speclines.project_id' => project.id, 'subsections.'+subsection_name+'_id' => subsection.id
                        ).order('clauserefs.subsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
                        ).uniq
                        }

#used
  scope :ref_subsection_clauses, ->(project_id, subsection_ids, subsection_name) { joins(:speclines, :clauseref => [:subsection]
                                     ).where('speclines.project_id' => project_id, 'subsections.'+subsection_name+'_id' => subsection_ids
                                     )}


  scope :changed_caws_clauses, ->(event, project, revision, subsection) { joins(:alterations, :clauseref => :subsection
    ).where('alterations.event' => event, 'alterations.clause_add_delete' => 2, 'alterations.project_id' => project.id, 'alterations.revision_id' => revision.id, 'subsections.cawssubsection_id' => subsection.id
    ).order('clauserefs.subsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
    ).uniq}

  scope :changed_caws_clause_content, ->(event, project, revision, subsection) { joins(:alterations, :clauseref => :subsection
    ).where('alterations.clause_add_delete' => 1, 'alterations.project_id' => project.id, 'alterations.revision_id' => revision.id, 'subsections.cawssubsection_id' => subsection.id
    ).order('clauserefs.subsection_id, clauserefs.clausetype_id, clauserefs.clause_no, clauserefs.subclause'
    ).uniq}


  scope :cawssubsection_clauses, ->(project_id, cawssubsection_ids) { joins(:speclines, :clauseref => [:subsection]
                                     ).where('speclines.project_id' => project_id, 'subsections.cawssubsection_id' => cawssubsection_ids
                                     )}





  def clauseref_code
    clauseref.clausetype_id.to_s + sprintf("%02d", clauseref.clause_no).to_s + clauseref.subclause.to_s
  end



def caws_code
#this needs to be sorted, unclear what is going on
  return clauseref.subsection.cawssubsection.cawssection.ref.to_s + sprintf("%02d", clauseref.subsection.cawssubsection.ref).to_s + '.' + clauseref.clausetype_id.to_s + sprintf("%02d", clauseref.clause_no).to_s + clauseref.subclause.to_s
end

def uniclass_code
####
end

def caws_full_title
#this needs to be sorted, unclear what is going on
  return clauseref.subsection.cawssubsection.cawssection.ref.to_s + sprintf("%02d", clauseref.subsection.cawssubsection.ref).to_s + '.' + clauseref.clausetype_id.to_s + sprintf("%02d", clauseref.clause_no).to_s + clauseref.subclause.to_s + ' ' + clausetitle.text.to_s
end

def uniclass_full_title
####
end


def part_ref_title
  return clauseref.clausetype.text.to_s + ' ' + clauseref.clausetype_id.to_s + sprintf("%02d", clauseref.clause_no).to_s + clauseref.subclause.to_s + ': ' + clausetitle.text.to_s
end

def clause_code_title_in_brackets
  return '('+ clausetitle.text = ')'
end


def custom_validation_1
    if @title_text.blank?
      errors.add(:title_text, ": Clause title cannot be blank")
    end 
end

private
  def assign_title
    if @title_text
      text_exist = Clausetitle.where('BINARY text =?', @title_text).first
      if text_exist.blank?
         self.clausetitle = Clausetitle.create(:text => @title_text)
      else
         self.clausetitle = text_exist
      end    
    end
  end

end
