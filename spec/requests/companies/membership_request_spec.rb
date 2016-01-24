require 'spec_helper'

RSpec.describe 'Company membership request', type: :request do

  describe 'membership_requests#create' do
    let(:company) { create(:company) }
    let(:membership_request_path) { "/companies/#{company.id}/membership_requests" }

    context 'request unauthorized' do
      before { post membership_request_path }

      it 'should redirect to root url' do
        expect(response).to redirect_to(root_url)
      end
    end

    context 'request authorized' do
      let(:user) { create(:user)}

      before do
        allow_any_instance_of(ApplicationController)
          .to receive(:current_user).and_return(user)
      end
      before { post membership_request_path }

      it 'should create membership request' do
        expect(response).to redirect_to("/companies/#{company.id}")
        expect(company.membership_requests.last).to eq(user.company_membership_requests.last)
      end
    end
  end
end
