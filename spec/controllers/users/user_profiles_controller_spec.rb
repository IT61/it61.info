require 'rails_helper'

RSpec.describe Users::UserProfilesController, type: :controller do

  describe "GET #last_step_register" do
    it "returns http success" do
      get :last_step_register
      expect(response).to have_http_status(:success)
    end
  end

end
