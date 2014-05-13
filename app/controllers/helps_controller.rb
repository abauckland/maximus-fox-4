class HelpsController < ApplicationController
  before_action :set_tutorial, only: [:show]

  layout "users"

  # GET /helps
  # GET /helps.json
  def index
    @tutorials = Help.all
  end
  
  def show
    redirect_to @tutorial.video.to_s
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tutorial
      @tutorial = Help.find(params[:id])
    end

end
