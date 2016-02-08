require 'spec_helper'

describe Companies::MembershipRequestsController do
  describe 'GET index' do
    before do
      create_user_and_company
      get :index, company_id: @company
    end

    it { should render_template('index') }
  end

  describe 'POST create' do
    let(:post_request) { post :create, company_id: @company, membership_request: { company_id: @company.id } }

    before do
      @user = create :user
      @company = create(:company, :published)
      login_user
    end

    it 'creates membership request' do
      expect { post_request }.to change(Company::MembershipRequest, :count).by(1)
    end

    it 'assigns user to request' do
      post_request

      created_request = Company::MembershipRequest.last
      expect(created_request.user).to eq @user
    end

    it 'sets flash' do
      post_request

      should set_flash[:success]
    end

    it 'redirects to company' do
      post_request

      should redirect_to(@company)
    end
  end

  describe 'PATCH approve' do
    let(:membership_request) { create(:membership_request, company: @company) }
    let(:patch_approve) { patch :approve, company_id: @company, id: membership_request.id }

    before do
      create_user_and_company
    end

    it 'calls #approve! of the membership request' do
      expect_any_instance_of(Company::MembershipRequest).to receive(:approve!)

      patch_approve
    end

    it 'redirects to index' do
      patch_approve

      should redirect_to(company_membership_requests_url)
    end
  end

  describe 'PATCH hide' do
    let(:membership_request) { create(:membership_request, company: @company) }
    let(:patch_hide) { patch :hide, company_id: @company, id: membership_request.id }

    before do
      create_user_and_company
    end

    it 'calls #hide! of the membership request' do
      expect_any_instance_of(Company::MembershipRequest).to receive(:hide!)

      patch_hide
    end

    it 'redirects to index' do
      patch_hide

      should redirect_to(company_membership_requests_url)
    end
  end

  def create_user_and_company
    @user = create :user
    @company = create(:company, founder: @user)
    login_user
  end
end


