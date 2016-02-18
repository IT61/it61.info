class Companies::MembershipRequestsController < ApplicationController
  respond_to :html
  responders :flash
  load_and_authorize_resource :company
  load_and_authorize_resource class: Company::MembershipRequest, through: :company

  has_scope :recent, type: :boolean, allow_blank: true
  has_scope :hidden, type: :boolean, allow_blank: true, default: false
  has_scope :approved, type: :boolean, allow_blank: true, default: false
  has_scope :page, default: 1
  has_scope :per, default: 10

  def index
    @membership_requests = apply_scopes(@membership_requests)
    respond_with @membership_requests
  end

  def create
    @membership_request.update!(user: current_user)

    respond_with @membership_request do |format|
      format.html { redirect_to :back }
    end
  end

  def approve
    @membership_request.approve!

    respond_with @membership_request, location: { action: :index }
  end

  def hide
    @membership_request.hide!

    respond_with @membership_request, location: { action: :index }
  end

  private

  def membership_request_params
    params.require(:membership_request).permit(:company_id)
  end

  def interpolation_options
    { company_title: @membership_request.company.title,
      user_name: @membership_request.user.full_name }
  end
end
