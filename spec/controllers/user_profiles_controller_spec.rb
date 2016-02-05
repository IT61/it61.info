require 'spec_helper'

describe UserProfilesController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    login_user(user)
  end
  
  context "#DELETE destroy" do
    it 'destroy user' do
      expect do
        delete :destroy, id: user.id
      end.to change(User, :count).by(-1)
    end

    context 'email notifications' do
      before(:each) do
        allow(AdminMailer).to receive(:deleting_user) do
          mock = double
          allow(mock).to receive(:deliver!)
          mock
        end
      end

      it 'notice admins about user deleting' do
        FactoryGirl.create(:admin)
        expect(AdminMailer).to receive(:deleting_user)
        delete :destroy, id: user.id
      end
    end

  end
end
