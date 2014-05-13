class FaqsController < ApplicationController

  layout "websites"
  
  # GET /faqs
  # GET /faqs.json
  def index
    @faqs = Faq.all
  end

end
