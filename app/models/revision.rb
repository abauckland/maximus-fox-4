class Revision < ActiveRecord::Base
#associations
  belongs_to :project
  has_many :alterations
  has_many :prints

  enum status: [:Draft, :Preliminary, :Tender, :Contract, :As_Built]


end
