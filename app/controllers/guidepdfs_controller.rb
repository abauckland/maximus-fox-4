class GuidepdfsController < ApplicationController

    skip_before_filter :authenticate_user!, :only => [:download]

    def index
      @guidepdfs = Guidepdf.all
    end

    def new
      @guidepdf = Guidepdf.new
    end

    # POST /pages
    def create
      @guidepdf = Guidepdf.new(help_params)

      if @guidepdf.save
      else
        render guidepdfs_path
      end
    end

    def download
      #subsection = Subsection.where(:id => params[:id]).first
      #@project = Project.first
      @guidepdf = Guidepdf.where(:id => params[:id]).first
  
      if @guidepdf
  
        send_file(@guidepdf.guide.path, :type => 'application/pdf', :filename => @guidepdf.pdf_file_name)
  
      #send_file("#{Rails.root}/public#{@guidepdf.pdf.url.sub!(/\?.+\Z/, '') }", :type => 'application/pdf', :filename => @guidepdf.pdf_file_name)
      #record download
  #      if defined?(:current_user)
  #        if current_user
  #        current_user_id = current_user.id
          #capture IP address
  #        @guide_downloads = Guidedownload.create(:guidepdf_id => @guidepdf.id, :user_id => current_user_id, :ipaddress => request.remote_ip)
  #        else
  #        @guide_downloads = Guidedownload.create(:guidepdf_id => @guidepdf.id, :ipaddress => request.remote_ip)
  #        end
  #      end
      end
      return
    end
    
end