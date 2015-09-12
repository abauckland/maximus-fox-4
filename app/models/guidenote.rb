class Guidenote < ActiveRecord::Base
  has_many :clauses

  has_many :clauseguides

  validates :text, presence: true,
    uniqueness: {message: ": A guide with the same description already exists for the company" }

end
