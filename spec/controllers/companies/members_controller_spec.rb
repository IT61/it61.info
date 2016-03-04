require 'spec_helper'

describe Companies::MembersController, type: :controller do
  let(:admin)        { FactoryGirl.create(:admin) }
  let(:company)      { FactoryGirl.create(:company) }
  let(:user_member)  { FactoryGirl.create(:company_member, company: company) }

  let(:valid_params) do
    { company_id: company.permalink, company_member: {company_id: company.id} }
  end

  before(:each) do
    login_user(admin)
    request.env["HTTP_REFERER"] = root_url
  end
  
  context "#DELETE destroy." do

    it 'delete record' do  #не находится mebmer_request
      user_member
      expect do
        delete :destroy, company_id: user_member.company_id, id: user_member.id
      end.to change(Company::Member, :count).by(-1)
    end

    context 'email notifications' do
      let(:delivery)  { fake_delivery }

      it 'notices admins about deleting user from company' do #не находится mebmer_request
        admin_member = FactoryGirl.create(:company_admin, company: company)
        expect(AdminMailer).to receive(:delete_user_from_company) do |user, company, deleting_user|
          expect(user).to eq(admin_member.user)
          expect(company).to eq(user_member.company)
          expect(deleting_user).to eq(user_member.user)
          delivery
        end

        delete :destroy, company_id: user_member.company_id, id: user_member.id
      end

      it 'notices user about deleting from company' do #не находится mebmer_request
        FactoryGirl.create(:company_admin, company: company)
        expect(UserMailer).to receive(:notice_about_delete) do |user, company|
          expect(company).to eq(user_member.company)
          expect(user).to eq(user_member.user)
          delivery
        end

        delete :destroy, company_id: user_member.company_id, id: user_member.id
      end
    end
  end

end
