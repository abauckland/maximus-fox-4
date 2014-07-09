class Company < ActiveRecord::Base
  
  has_many :users
  has_many :identvalues
  
  mount_uploader :logo, LogoUploader

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
 
  def custom_validation_check_field
    if @check_field !=''
      errors.add(:check_field, "Cannot be blank")
    end     
  end

  def details
  #this needs to be sorted, unclear what is going on
    return name+', Tel: 0'+tel.to_s[0..2]+' '+tel.to_s[3..5]+' '+tel.to_s[6..9]+', Web: '+www+'.'
  end

      
end
