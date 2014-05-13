class Project < ActiveRecord::Base
#associations
  has_many :users, :through => :projectusers
  has_many :speclines
  has_many :clauses, :through => :speclines
  has_many :revisions
  has_many :alterations
  has_attached_file :photo 


  enum project_status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]
  enum ref_system: [:caws, :uniclass]
  enum rev_method: [:document, :subsection]


  validates_presence_of :code
  validates_presence_of :title

  validates_attachment_presence :photo unless :photo
  validates_attachment :photo,
    :on => :create,
    :attachment_content_type => { :content_type => ["image/png", "image/jpg"] },
    :size => { :in => 0..1000.kilobytes }

  

  scope :user_projects, -> { joins(:projectusers).where('projectusers.user_id' => current_user.id).order("code")} 
   
  scope :project_template, ->(project) { where(:id => project.id).first }

  scope :project_templates, ->(project) { joins(:projectusers
                              ).where('projectusers.user_id' => current_user.id
                              ).where.not(:id => project.id
                              ).order("code")}
  
  scope :cawssubsection_project_templates, ->(project, subsection) { joins(:projectusers, :speclines => [:clauses => [:clauserefs => :subsections]]
                              ).where('projectusers.user_id' => current_user.id
                              ).where('subsections.cawssubsection_id' => subsection.id
                              ).where.not(:id => project.id
                              ).order("code")}

  
  def code_and_title
    return code+' '+title
  end

  Paperclip.interpolates :normalized_video_file_name do |attachment, style|
    attachment.instance.normalized_image_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.video_image_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
