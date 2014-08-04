class CompanyMembersController < ApplicationController
  respond_to :html
  load_and_authorize_resource param_method: :company_member_params

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, flash: { error: exception.message }
  end

  def create
    @company_member.user = current_user || nil
    @company_member.save!

    flash[:success] = t(:company_member_created, title: @company_member.company.title)
    redirect_to :back
  end

  def destroy
    @company_member.destroy!

    flash[:success] = t(:company_membership_canceled, title: @company_member.company.title)
    redirect_to :back
  end

  private

  def company_member_params
    params.require(:company_member).permit(:company_id)
  end
end
