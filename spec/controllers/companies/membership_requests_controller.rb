require 'spec_helper'

describe Companies::MembershipRequestsController, type: :controller do
  let(:user)    { FactoryGirl.create(:user) }
  let(:company) { FactoryGirl.create(:company) }

  let(:valid_params) do
    { company_id: company.permalink, membership_request: {company_id: company.id} }
  end

  before(:each) do
    login_user(user)
  end

  context "#POST create" do
    it 'creates new Company::MembershipRequest' do
      expect do
        post :create, valid_params
      end.to change(Company::MembershipRequest, :count).by(1)
    end

    context 'email notifications' do
      before(:each) do
        allow(AdminMailer).to receive(:request_to_membership) do
          mock = double
          allow(mock).to receive(:deliver!)
          mock
        end
        allow(UserMailer).to receive(:notice_about_request) do
          mock = double
          allow(mock).to receive(:deliver!)
          mock
        end
      end

      it 'notices admins about request_to_membership' do 
        FactoryGirl.create(:admin)
        expect(AdminMailer).to receive(:request_to_membership)
        post :create, valid_params
      end

      it 'notices user about notice_about_request' do
        expect(UserMailer).to receive(:notice_about_request)
        post :create, valid_params
      end
    end
  end

end
