require 'spec_helper'

describe PasswordResetsController do
  describe 'POST create' do
    before { ActionMailer::Base.deliveries.clear }
    let(:user_attrs) { attributes_for(:user) }

    context 'not existing email address' do
      it "'doesn't send an email'" do
        post :create, email: 'notexisting@mail.com'
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end

    context 'user with a valid email' do
      let(:user) { create :user }

      it 'sends an email with instructions' do
        post :create, email: user.email
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end

    it 'redirects to the root url' do
      post :create, email: user_attrs[:email]
      expect(response).to redirect_to(root_url)
    end

    it 'sets a flash message' do
      post :create, email: user_attrs[:email]
      expect(flash.empty?).not_to be
    end
  end

  describe 'GET edit' do
    context 'valid token' do
      let(:user) { create :user, :with_reset_password_token }

      it 'renders the #edit view' do
        get :edit, id: user.reset_password_token
        expect(response).to render_template(:edit)
      end
    end

    context 'invalid token' do
      it 'redirects to the root url' do
        invalid_token = 'invalid token'
        get :edit, id: invalid_token
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'PUT update' do
    let(:user) { create :user, :with_reset_password_token }
    let(:user_attrs) { attributes_for(:user, password: 'new_password', password_confirmation: 'new_password') }

    context 'valid attributes' do
      it 'locates user by token' do
        put :update, id: user.reset_password_token, user: user_attrs
        expect(assigns(:user)).to eq(user)
      end

      it "changes user's password" do
        put :update, id: user.reset_password_token, user: user_attrs
        user.reload
        expect(User.authenticate(user.email, user_attrs[:password])).to be_true
      end

      it 'redirects to the root url after update' do
        put :update, id: user.reset_password_token, user: user_attrs
        expect(response).to redirect_to(root_url)
      end
    end

    context 'invalid attributes' do
      let(:user_attrs) { attributes_for(:user, password: 'password1', password_confirmation: 'password2') }

      it "re-renders the edit template when passwords don't match" do
        put :update, id: user.reset_password_token, user: user_attrs
        expect(response).to render_template(:edit)
      end
    end

    context 'invalid token' do
      it 'redirects to the root url' do
        invalid_token = 'invalid token'
        put :update, id: invalid_token, user: user_attrs
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
