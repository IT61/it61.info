class Companies::MembersController < ApplicationController
  respond_to :html
  load_and_authorize_resource param_method: :company_member_params, class: Company::Member

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
    # @company_member = Company::Member.find(params[:id])
    @company_member.destroy!
    flash[:success] = t(:company_membership_canceled, title: @company_member.company.title)
    notice_user_and_admins_about_deliting_user_from_comapny
    redirect_to :back
  end

  private

    def company_member_params
      params.require(:company_member).permit(:company_id)
    end

    def notice_user_and_admins_about_deliting_user_from_comapny
      #TODO Move all notices to resque/delayed_job/sidekiq
      @company_member.company.members.with_roles(:admin).each do |company_admin|
        AdminMailer.deleting_user(company_admin, @company_member.company).deliver!
      end
      UserMailer.notice_about_delete(@company_member.user, @company_member.company) #TODO change two parameters to one membership_request

    end
end
