class Unisubsection < ActiveRecord::Base
  belongs_to :unisection
  has_many :subsections
end
