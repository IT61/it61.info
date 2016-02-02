class Companies::MembershipRequestsController < ApplicationController
  respond_to :html
  load_and_authorize_resource :company
  load_and_authorize_resource class: Company::MembershipRequest, :through => :company
  before_filter :set_company, only: :create
  before_filter :set_user, only: :create

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, flash: { error: exception.message }
  end

  has_scope :recent, type: :boolean, allow_blank: true
  has_scope :hidden, type: :boolean, allow_blank: true, default: false

  def index
    @membership_requests = apply_scopes(@membership_requests)
    respond_with @membership_requests
  end

  def create
    @membership_request.save!

    flash[:success] = t(:company_membership_request_created, title: @membership_request.company.title)
    redirect_to(request.env['HTTP_REFERER'] ? :back : company_path(@membership_request.company))
  end

  def update
    @membership_request.update_attributes membership_request_params
    redirect_to :back
  end

  def hide
    @membership_request.hide!
    redirect_to :back
  end

  private

  def membership_request_params
    permitted_attrs = [
        :company_id,
        :approved
    ]
    params.require(:membership_request).permit(*permitted_attrs)
  end

  def set_company
    @membership_request.company = @company
  end

  def set_user
    @membership_request.user = current_user
  end
end

