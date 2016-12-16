RSpec.describe Admin::UsersController, type: :controller do
  context "while logged in as an user" do
    login_user

    describe "get /index" do
      it "redirects to /welcome" do
        get :index
        expect(response.status).to eq(302)
      end
    end
  end

  context "while logged in as an admin" do
    login_admin

    describe "get /index" do
      it "renders #index" do
        get :index
        expect(response.status).to eq(200)
      end
    end
  end
end
