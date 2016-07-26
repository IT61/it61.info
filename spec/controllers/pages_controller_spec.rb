# frozen_string_literal: true
require "rails_helper"

RSpec.describe PagesController, type: :controller do
  describe "GET #welcome" do
    it "returns http success" do
      get :welcome
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #sponsorship" do
    it "returns http success" do
      get :sponsorship
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #slack" do
    it "returns http success" do
      get :slack
      expect(response).to have_http_status(:success)
    end
  end
end
