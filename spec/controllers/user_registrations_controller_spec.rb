require 'spec_helper'

describe UserRegistrationsController, type: :controller do
  let(:user_attrs) { FactoryGirl.attributes_for(:user) }

  context 'POST create' do
    it 'success with email and passwords submitted' do
      expect do
        post :create, user: user_attrs
      end.to change(User, :count).by(1)
    end

    it 'success with authentication and empty password' do
      attrs = FactoryGirl.attributes_for(:oauth_user)
      expect do
        post :create, user: attrs
      end.to change(User, :count).by(1)
    end

    it 'redirect to root path after user creation' do
      response = post :create, user: user_attrs
      expect(response).to redirect_to(root_path)
    end

    it 'user is subscribed after creation' do
      attrs = FactoryGirl.attributes_for(:oauth_user)
      post :create, user: attrs

      created_user = User.last
      expect(created_user).to be_subscribed
    end

    context 'email notifications' do
      before(:each) do
        allow(AdminMailer).to receive(:adding_user) do
          mock = double
          allow(mock).to receive(:deliver!)
          mock
        end
      end

      it 'notice admins about adding new user' do
        FactoryGirl.create(:admin)
        expect(AdminMailer).to receive(:adding_user)
        post :create, user: user_attrs
      end
    end
  end
  
end
