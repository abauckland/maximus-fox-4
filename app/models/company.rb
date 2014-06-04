class Company < ActiveRecord::Base
  
  has_many :users
  has_many :identvalues

  has_attached_file :photo
  accepts_nested_attributes_for :users, allow_destroy: true

  attr_accessor :check_field 
  
  enum category: [:client, :designer, :contractor, :supplier]

  
  before_validation :custom_validation_check_field, on: :create
  
  validates :read_term,
            on: :create, 
            :acceptance => { :accept => 1 }

  validates :name,
            on: :create,    
            :presence => true,   
            :length => {:minimum => 3, :maximum => 254},
            :uniqueness => {:message => "An account for the company already exists, please contact us for details"} 



  validates_attachment_content_type :photo, content_type: { content_type: ["image/jpg", "image/png"]}
  
  validates_attachment :photo,
    :on => :create,
    :size => { :in => 0..1000.kilobytes }


  
  def custom_validation_check_field
    if @check_field !=''
      errors.add(:check_field, "Cannot be blank")
    end     
  end

  def details
  #this needs to be sorted, unclear what is going on
    return name+', Tel: 0'+tel.to_s[0..2]+' '+tel.to_s[3..5]+' '+tel.to_s[6..9]+', Web: '+www+'.'
  end



  Paperclip.interpolates :normalized_video_file_name do |attachment, style|
    attachment.instance.normalized_image_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.video_image_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end
      
end
