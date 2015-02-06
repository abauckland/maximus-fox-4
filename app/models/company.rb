class Company < ActiveRecord::Base
  
  has_many :users
  has_many :identvalues
  has_many :projects

  mount_uploader :logo, LogoUploader

#  attr_accessor :check_field
  enum category: [:client, :designer, :contractor, :supplier]

#  before_validation :custom_validation_check_field, on: :create

  validates :name,
   on: :create,
   presence: true,
   length: {:minimum => 3, :maximum => 254},
   uniqueness: { case_sensitive: false, message: "An account for a company with the same name already exists, please contact us for details" },
   format: { with: COMPANY_NAME_REGEXP, message: "please enter a valid name" }

  validates :read_term,
            on: :create,
            acceptance: { :accept => 1, message: "Please confirm you have read the terms and conditions" }


#  def custom_validation_check_field
#    if @check_field !=''
#      errors.add(:check_field, "Cannot be blank")
#    end
#  end


  def details
  #this needs to be sorted, unclear what is going on
    return name+', Tel: 0'+tel.to_s[0..2]+' '+tel.to_s[3..5]+' '+tel.to_s[6..9]+', Web: '+www+'.'
  end
 
end
