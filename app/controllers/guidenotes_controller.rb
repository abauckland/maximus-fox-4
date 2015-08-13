
  class GuidenotesController < ApplicationController

#    skip_before_filter :authenticate_user!, :only => [:show]

    before_action :set_guidenote, only: [:edit, :update, :create, :destroy]


    def index
      @guidenotes = Guidenote.all.order(:text)
      authorize @guidenotes
    end

#    # GET /guidenotes/1
#    def show
#      @guidenote = Guidenote.where(:id => params[:id]).first
#      render :text=> @guidenote.text 
#    end

    def new
      @guidenote = Guidenote.new
    end

    # GET /guidenotes/1/edit
    def edit
      authorize @guidenote
    end

    # POST /pages
    def create
      @guidenote = Guidenote.new(guidenote_params)
      authorize @guidenote
      if @guidenote.save
      else
        render guidenotes_path
      end
    end


    # PATCH/PUT /guidenotes/1
    def update
      authorize @guidenote
      if @guidenote.update(guidenote_params)
#on create redirect back to dashbard
        redirect_to guidenotes_path, notice: 'guidenote item was successfully updated.'
      else
        render guidenotes_path
      end
    end

    # DELETE /pages/1
    def destroy
      @guidenote.destroy
      redirect_to guidenotes_url, notice: 'guidenote item was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_guidenote
        @guidenote = Guidenote.where(:id => params[:id]).first
      end

      # Only allow a trusted parameter "white list" through.
      def guidenote_params
        params.require(:guidenote).permit(:id, :description, :text)
      end
  end

