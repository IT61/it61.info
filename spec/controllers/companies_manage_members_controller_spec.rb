require 'spec_helper'

describe Companies::Manage::MembersController, type: :controller do
  let(:user) { create :user }

  before do
    login_user user
  end

  describe 'PATCH update' do
    let(:company_member) { create(:company_member, :admin, user: user) }
    let(:new_roles) { [:admin, :employee] }

    it 'changes company member attributes' do
      request.accept = 'application/json'
      patch :update, id: company_member, member: { roles: new_roles }
      expect(company_member.reload.roles).to match_array(new_roles)
    end
  end
end
