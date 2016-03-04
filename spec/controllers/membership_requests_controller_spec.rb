require 'spec_helper'

describe Companies::MembershipRequestsController do
  let(:user) { create :user }
  let(:company) { create(:company, founder: user) }

  before do
    login_user user
  end

  describe 'GET index' do
    before do
      get :index, company_id: company
    end

    it { is_expected.to render_template('index') }
  end

  describe 'POST create' do
    let(:company) { create(:company, :published) }
    let(:post_request) { post :create, company_id: company, membership_request: { company_id: company.id } }

    it 'creates membership request' do
      expect { post_request }.to change(Company::MembershipRequest, :count).by(1)
    end

    it 'assigns user to request' do
      post_request

      created_request = Company::MembershipRequest.last
      expect(created_request.user).to eq user
    end

    it 'sets flash' do
      post_request

      is_expected.to set_flash[:success]
    end

    it 'redirects to company' do
      post_request

      is_expected.to redirect_to(company)
    end

    context 'email notifications' do
      let(:delivery) { fake_delivery }

      it 'notices admins about request_to_membership' do 
        company_admin = FactoryGirl.create(:company_admin, company: company)
        allow(AdminMailer).to receive(:request_to_membership) do |admin, source_company, new_user|
          expect(admin).to eq(company_admin.user)
          expect(source_company).to eq(company)
          expect(new_user).to eq(user)
          delivery
        end

        expect(AdminMailer).to receive(:request_to_membership)
        post_request
      end

      it 'notices user about notice_about_request' do
        allow(UserMailer).to receive(:notice_about_request) do |new_user, source_company|
          expect(new_user).to eq(user)
          expect(source_company).to eq(company)
          delivery
        end

        expect(UserMailer).to receive(:notice_about_request)
        post_request
      end
    end
  end

  describe 'PATCH approve' do
    let(:membership_request) { create(:membership_request, company: company) }
    let(:patch_approve) { patch :approve, company_id: company, id: membership_request.id }

    it 'calls #approve! of the membership request' do
      expect_any_instance_of(Company::MembershipRequest).to receive(:approve!)

      patch_approve
    end

    it 'redirects to index' do
      patch_approve

      is_expected.to redirect_to(company_membership_requests_url)
    end

    context 'email notifications' do
      let(:delivery) { fake_delivery }

      it 'notices admins about new_company_user' do 
        company_admin = FactoryGirl.create(:company_admin, company: company)
        allow(AdminMailer).to receive(:new_company_user) do |admin, source_company, new_user|
          expect(admin).to eq(company_admin.user)
          expect(source_company).to eq(membership_request.company)
          expect(new_user).to eq(membership_request.user)
          delivery
        end

        expect(AdminMailer).to receive(:new_company_user)
        patch_approve
      end

      it 'notices user about notice_about_accept' do
        allow(UserMailer).to receive(:notice_about_accept) do |new_user, source_company|
          expect(new_user).to eq(membership_request.user)
          expect(source_company).to eq(membership_request.company)
          delivery
        end

        expect(UserMailer).to receive(:notice_about_accept)
        patch_approve
      end
    end

  end

  describe 'PATCH hide' do
    let(:membership_request) { create(:membership_request, company: company) }
    let(:patch_hide) { patch :hide, company_id: company, id: membership_request.id }

    it 'calls #hide! of the membership request' do
      expect_any_instance_of(Company::MembershipRequest).to receive(:hide!)

      patch_hide
    end

    it 'redirects to index' do
      patch_hide

      is_expected.to redirect_to(company_membership_requests_url)
    end
  end

  describe 'handling rescue from CanCan::AccessDenied exceptions' do
    let(:company) { create(:company) }

    before do
      get :index, company_id: company
    end

    it { is_expected.to redirect_to(root_url) }
    it { is_expected.to set_flash[:error] }
  end
end


