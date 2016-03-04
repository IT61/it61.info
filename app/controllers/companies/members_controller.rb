class Companies::MembersController < ApplicationController
  respond_to :html
  load_and_authorize_resource class: Company::Member

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, flash: { error: exception.message }
  end

  def destroy
    @member.destroy! 
    flash[:success] = t(:company_membership_canceled, title: @member.company.title)
    notice_user_and_admins_about_deliting_user_from_company(@member.company, @member.user)
    redirect_to :back
  end

  private

    def notice_user_and_admins_about_deliting_user_from_company(company, user)
      company.members.with_roles(:admin).each do |company_admin|
        AdminMailer.delete_user_from_company(company_admin.user, company, user).deliver_later
      end
      UserMailer.notice_about_delete(user, company).deliver_later
    end
end
