class Companies::MembershipRequestsController < ApplicationController
  respond_to :html
  load_and_authorize_resource :company
  load_and_authorize_resource class: Company::MembershipRequest, :through => :company

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { error: exception.message }
  end

  has_scope :recent, type: :boolean, allow_blank: true
  has_scope :hidden, type: :boolean, allow_blank: true, default: false
  has_scope :approved, type: :boolean, allow_blank: true, default: false
  has_scope :page, default: 1, if: ->(controller) { controller.request.format.html? }
  has_scope :per, default: 10, if: ->(controller) { controller.request.format.html? }

  def index
    @membership_requests = apply_scopes(@membership_requests)
    respond_with @membership_requests
  end

  def create
    @membership_request.update!(user: current_user)

    flash[:success] = t(:company_membership_request_created, title: @membership_request.company.title)
    redirect_to(request.env['HTTP_REFERER'] ? :back : @membership_request.company)
  end

  def approve
    @membership_request.approve!

    flash[:success] = t('.success_message', name: @membership_request.user.full_name)
    redirect_to action: :index
  end

  def hide
    @membership_request.hide!
    redirect_to action: :index
  end

  private

  def membership_request_params
    params.require(:membership_request).permit(:company_id)
  end
end
