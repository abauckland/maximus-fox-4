class AboutsController < ApplicationController
  
  layout "websites"
  
  # GET /faqs
  # GET /faqs.json
  def index
    @contents = About.all
  end

end
