class Client < ActiveRecord::Base

  belongs_to :project
  
  has_attached_file :photo 
  
  validates_attachment_presence :photo unless :photo
  validates_attachment :photo,
    :on => :create,
    :attachment_content_type => { :content_type => ["image/png", "image/jpg"] },
    :size => { :in => 0..1000.kilobytes }


  Paperclip.interpolates :normalized_video_file_name do |attachment, style|
    attachment.instance.normalized_image_file_name
  end

  def normalized_video_file_name
    "#{self.id}-#{self.video_image_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  end

end
