class Companies::MembersController < ApplicationController
  respond_to :html
  load_and_authorize_resource class: Company::Member

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, flash: { error: exception.message }
  end

  def destroy
    @member.destroy!
    # TODO set the flash text depending on a deletion context
    flash[:success] = t(:company_membership_canceled, title: @member.company.title)
    redirect_to :back
  end
end
