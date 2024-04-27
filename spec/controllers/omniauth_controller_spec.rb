require 'rails_helper'

RSpec.describe Users::OmniauthController do
  context 'GitHub' do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    end

    context 'when user authenticated already' do
      let!(:user) { create(:user) }
      let!(:social_account) { create(:social_account, user: user) }

      before do
        sign_in(user)
      end

      it 'adds a social network to the current user' do
        expect {
          post :github
        }.to change(SocialAccount, :count).by(1)

        expect(user.social_accounts.last.provider).to eq('github')
      end
    end

    it 'redirects to complete sign up URL' do
      post :github

      expect(response).to redirect_to(sign_up_complete_url)
    end

    it 'creates user from OmniAuth params' do
      expect {
        post :github
      }.to change(User, :count).by(1).and change(SocialAccount, :count).by(1)
    end
  end
end
