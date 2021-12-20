require 'rails_helper'

RSpec.describe "/note", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:note) { FactoryBot.create(:note, user: user) }

  before { sign_in(user) }

  describe "GET /index" do
    context "with sign in user" do
      it "renders a successful response" do
        get root_path

        expect(response).to be_successful
      end

      it "has corect body" do
        get root_path

        expect(response.body).to include note.city
        expect(response.body).to include note.description
      end
    end

    context "with sign out user" do
      it "renders a successful response" do
        sign_out user

        get root_path

        expect(response).to be_successful
      end

      it "has corect body" do
        sign_out user

        get root_path

        expect(response.body).to_not include note.city
        expect(response.body).to_not include note.description
      end

    end

  end
end