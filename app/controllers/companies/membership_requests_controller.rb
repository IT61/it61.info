class Companies::MembershipRequestsController < ApplicationController
  respond_to :html
  load_and_authorize_resource class: Company::MembershipRequest
  before_filter :set_company, only: :create

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

    flash[:success] = t(:company_membership_request_created, title: @membership_request.company.title)
    redirect_to(request.env['HTTP_REFERER'] ? :back : company_path(@membership_request.company))
  end

  private

  def membership_request_params
    params.permit(:company_id)
  end

  def fetch_company
    @company ||= Company.find(params[:company_id])
  end

  def set_company
    @membership_request.company = fetch_company
  end
end

