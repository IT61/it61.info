require 'spec_helper'

describe Companies::MembersController, type: :controller do
  let(:admin)         { FactoryGirl.create(:admin) }
  let(:company)      { FactoryGirl.create(:company) }
  let(:user_member)  { FactoryGirl.create(:company_member, company: company) }

  let(:valid_params) do
    { company_id: company.permalink, company_member: {company_id: company.id} }
  end

  before(:each) do
    login_user(admin)
  end

  context "#DELETE destroy." do
    before(:each) do
      request.env["HTTP_REFERER"] = root_url
    end

    it 'delete record' do
      user_member
      expect do
        delete :destroy, company_id: user_member.company_id, id: user_member.id
      end.to change(Company::Member, :count).by(-1)
    end

    context 'email notifications' do
      before(:each) do
        allow(AdminMailer).to receive(:deleting_user) do
          mock = double
          allow(mock).to receive(:deliver!)
          mock
        end
      end

      it 'notice admins about deleting user from company' do #ломаются из-за  в user.rb
        FactoryGirl.create(:company_admin, company: company)
        expect(AdminMailer).to receive(:deleting_user)
        delete :destroy, company_id: user_member.company_id, id: user_member.id
      end
    end

  end

end
