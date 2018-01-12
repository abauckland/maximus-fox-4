class GuidesController < ApplicationController

  def show
    @guidenote = Guide.find(params[:id])
    render @guidenote
  end

end