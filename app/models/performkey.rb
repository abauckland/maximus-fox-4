class Performkey < ActiveRecord::Base
#associations    
  has_many :performs

#methods
  def retrieve_or_create(text)
    if text == ""
      existing_key = self.first
    else
      existing_key = Performkey.where(:text => text).first
      if existing_key.blank?
         new_key = Performkey.create(:text => text)
      else
         new_key = existing_key
      end
    end
  end

end
