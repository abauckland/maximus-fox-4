class CompaniesController < ApplicationController

  before_action :set_company

  layout "users"


  def edit
    authorize @company
  end


  def update
    authorize @company

      if @company.update(company_params)
        redirect_to edit_company_path(@company), notice: 'Company was successfully updated.'
      else
        render :edit
      end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit({:users_attributes => [:first_name, :surname, :email, :role, :active, :password, :password_confirmation, :state]}, :check_field, :name, :tel, :www, :reg_address, :reg_number, :reg_name, :reg_location, :read_term, :category, :logo, :no_licence)
    end

end
