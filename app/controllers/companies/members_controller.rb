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
      #TODO Move all notices to resque/delayed_job/sidekiq
      company.members.with_roles(:admin).each do |company_admin|
        AdminMailer.deleting_user(company_admin, company).deliver!
      end
      UserMailer.notice_about_delete(user, company)

    end
end
