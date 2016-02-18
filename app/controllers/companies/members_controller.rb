class Companies::MembersController < ApplicationController
  respond_to :html
  responders :flash
  load_and_authorize_resource class: Company::Member

  def destroy
    @member.destroy!

    respond_with @member do |format|
      format.html { redirect_to :back }
    end
  end

  private

  def interpolation_options
    { company_title: @member.company.title }
  end
end
