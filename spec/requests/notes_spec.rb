require 'rails_helper'

RSpec.describe "/note", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:note) { FactoryBot.create(:note, user: user) }
  let(:valid_attributes) { FactoryBot.attributes_for(:note, user: user) }
  let(:invalid_attributes) { FactoryBot.attributes_for(:note, city: nil, user: user) }

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

  describe "POST /create" do
    context "with sign in user" do
      it "creates a new note with valid attributes" do
        expect {
          post create_path, params: { note: valid_attributes }
        }.to change(Note, :count).by(1)
      end

      it "redirects to the root_path with notice with valid attributes" do
        post create_path, params: { note: valid_attributes }

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq "Note successfully created"
      end

      it "does not create a new note with invalid attribute" do
        expect {
          post create_path, params: { note: invalid_attributes }
        }.to change(Note, :count).by(0)
      end

      it "redirects to the root_path with alert with invalid attribues" do
        post create_path, params: { note: invalid_attributes }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "City can't be blank"
      end
    end

    context "with sign out user" do
      it "does not create a new note" do
        sign_out user
        
        expect {
          post create_path, params: { note: valid_attributes }
        }.to change(Note, :count).by(0)
      end
      it "redirects to the root_path with alert" do
        sign_out user

        post create_path, params: { note: valid_attributes }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "You need to sign in to create a note"
      end
    end
  end
end