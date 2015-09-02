class Help < ActiveRecord::Base

   validates :item, presence: true, uniqueness: { case_sensitive: false, message: "A help item for the same reference already exists" }

end