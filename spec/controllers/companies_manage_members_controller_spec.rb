require 'spec_helper'

describe Companies::Manage::MembersController, type: :controller do
  let(:user) { create :user }

  before do
    login_user user
  end

  describe 'PATCH update' do
    let(:company) { create(:company, founder: user) }
    let(:company_member) { create(:company_member, company: company) }
    let(:new_roles) { [:admin, :employee] }

    it 'changes company member attributes' do
      request.accept = 'application/json'
      patch :update, id: company_member, member: { roles: new_roles }
      expect(company_member.reload.roles).to match_array(new_roles)
    end
  end

  describe 'DELETE destroy' do
    let!(:company_member) { create(:company_member, :admin, user: user) }
    let(:delete_destroy) { delete :destroy, id: company_member }

    it 'deletes the company member' do
      expect { delete_destroy }.to change(Company::Member, :count).by(-1)
    end

    it 'redirects to index' do
      delete_destroy

      is_expected.to redirect_to(company_manage_members_url(company_member.company))
    end

    it 'sets flash' do
      delete_destroy

      is_expected.to set_flash[:success]
    end
  end
end
