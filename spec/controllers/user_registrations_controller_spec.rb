require 'spec_helper'

describe UserRegistrationsController do
  let(:user_attrs) { FactoryGirl.attributes_for(:user) }

  context 'POST create' do
    specify 'success with email and passwords submitted' do
      expected_quantity = User.all.count + 1
      post :create, user: user_attrs

      expect(User.all.count).to eq(expected_quantity)
    end

    specify 'success with authentication and empty password' do
      expected_quantity = User.all.count + 1
      attrs = FactoryGirl.attributes_for(:oauth_user)
      post :create, user: attrs

      expect(User.all.count).to eq(expected_quantity)
    end

    specify 'redirect to root path after user creation' do
      response = post :create, user: user_attrs
      expect(response).to redirect_to(root_path)
    end

    specify 'user is subscribed after creation' do
      attrs = FactoryGirl.attributes_for(:oauth_user)
      post :create, user: attrs

      created_user = User.last
      expect(created_user).to be_subscribed
    end
  end
end