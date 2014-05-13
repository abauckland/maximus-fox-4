class HomesController < ActionController::Base

  layout "websites"

  def index
    @home = Home.first
  end
       
end