class CompaniesController < ApplicationController
  respond_to :html
  responders :flash

  load_resource param_method: :company_params
  before_filter :set_founder, only: :create
  authorize_resource

  def index
    @companies = apply_scopes(@companies).decorate
    respond_with @companies
  end

  def show
    @company = Company.find(params[:id]).decorate

    respond_with @company
  end


  def new
    @company = Company.new

    respond_with @company
  end

  def create
    @company.save
    respond_with @company
  end

  def edit
    @company = Company.find params[:id]

    respond_with @company
  end

  def update
    @company.update_attributes company_params
    respond_with @company
  end

  def publish
    @company.publish!
    flash[:success] = t('.success_message')
    redirect_to action: :show
  end

  def cancel_publication
    @company.cancel_publication!
    flash[:success] = t('.success_message')
    redirect_to action: :show
  end

  private

  def set_founder
    @company.founder = current_user || nil
  end

  def company_params
    permitted_attrs = [
      :title,
      :website,
      :description,
      :logo_image,
      :contacts
    ]
    params.require(:company).permit(*permitted_attrs)
  end
end
