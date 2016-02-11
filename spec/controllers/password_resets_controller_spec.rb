require 'spec_helper'

describe PasswordResetsController, type: :controller do
  describe 'POST create' do
    before do
      ActionMailer::Base.deliveries.clear
      @user = create :user
      post :create, email: email
    end

    context 'with a valid email' do
      let(:email) { @user.email }

      it 'sends an email with instructions' do
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it { expect(controller).to set_the_flash[:success] }
      it { expect(request).to redirect_to root_url }
    end

    context 'with not existing email' do
      let(:email) { 'notexisting@mail.com' }

      it 'does not sends an email' do
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it do
        expect(controller).to set_the_flash[:danger]
          .to(/Пользователь с таким Email не найден/).now
      end
      it { expect(response).to render_template(:new) }
    end
  end

  describe 'GET edit' do
    before do
      @user = create :user, :with_reset_password_token
      get :edit, id: token
    end

    context 'with a valid token' do
      let(:token) { @user.reset_password_token }

      it { expect(response).to render_template(:edit) }
    end

    context 'with an invalid token' do
      let(:token) { 'invalid_token' }

      it { expect(request).to redirect_to root_url }
    end
  end

  describe 'PUT update' do
    let(:user_new_password_attrs) { { password: 'new_password', password_confirmation: 'new_password' } }
    let(:reset_password_token) { @user.reset_password_token }

    before do
      @user = create :user, :with_reset_password_token
      put :update, id: reset_password_token, user: user_new_password_attrs
    end

    context 'with valid attributes' do
      it 'locates user by token' do
        expect(assigns(:user)).to eq(@user)
      end

      it "changes user's password" do
        @user.reload
        expect(User.authenticate(@user.email, user_new_password_attrs[:password])).to eq @user
      end

      it { expect(request).to redirect_to root_url }
    end

    context 'with invalid attributes' do
      let(:user_new_password_attrs) { { password: 'password1', password_confirmation: 'password2' } }

      it { expect(response).to render_template(:edit) }
    end

    context 'with an invalid token' do
      let(:reset_password_token) { 'invalid_token' }

      it { expect(request).to redirect_to root_url }
    end
  end
end
