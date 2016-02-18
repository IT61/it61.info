require 'spec_helper'

describe Companies::MembersController, type: :controller do
  include_context 'http referer'
  let(:user) { create :user }

  before do
    login_user user
  end

  describe 'DELETE destroy' do
    let!(:company_member) { create(:company_member, user: user) }
    let(:delete_destroy) { delete :destroy, id: company_member }

    it 'deletes the company member' do
      expect { delete_destroy }.to change(Company::Member, :count).by(-1)
    end

    it 'redirects back to referer' do
      delete_destroy

      is_expected.to redirect_to(http_referer)
    end

    it 'sets flash' do
      delete_destroy

      is_expected.to set_flash[:success]
    end
  end
end
