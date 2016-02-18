class Companies::Manage::MembersController < ApplicationController
  respond_to :html, :json
  load_and_authorize_resource :company
  load_and_authorize_resource class: Company::Member, through: :company, shallow: true

  has_scope :page, default: 1
  has_scope :per, default: 10

  def index
    @members = apply_scopes(@members)
    respond_with @members
  end

  def update
    @member.update_attributes member_params
    respond_with @member
  end

  private

  def member_params
    params.require(:member).permit(:roles => [])
  end
end
