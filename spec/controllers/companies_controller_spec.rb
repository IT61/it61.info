RSpec.describe CompaniesController, type: :controller do
  context "GET index" do
    it "reads like a sentence" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
