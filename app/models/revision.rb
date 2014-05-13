class Revision < ActiveRecord::Base
#associations
  belongs_to :project
  has_many :alterations

  enum status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]

end
