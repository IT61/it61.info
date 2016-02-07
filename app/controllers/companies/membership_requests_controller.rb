class Companies::MembershipRequestsController < ApplicationController
  respond_to :html
  load_and_authorize_resource class: Company::MembershipRequest

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { error: exception.message }
  end

  has_scope :recent, type: :boolean, allow_blank: true
  has_scope :by_company, as: :company_id

  def index
    @membership_requests = apply_scopes(@membership_requests)
    respond_with @membership_requests
  end

  def create
    authorize! :create, @membership_request

    @membership_request.user = current_user
    @membership_request.save!
    notice_user_and_admins_about_new_request_to_membership

    flash[:success] = t(:company_membership_request_created, title: @membership_request.company.title)
    redirect_to(request.env['HTTP_REFERER'] ? :back : company_path(@membership_request.company))
  end

  private

    def membership_request_params
      params.require(:membership_request).permit(:company_id)
    end

    def notice_user_and_admins_about_new_request_to_membership
      #Move all notices to resque/delayed_job/sidekiq
      User.admins.each do |admin|
        AdminMailer.request_to_membership(admin, @membership_request.company).deliver!
      end
      UserMailer.notice_about_request(current_user, @membership_request.company) #TODO change two parameters to one membership_request
    end

end

