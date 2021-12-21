require 'rails_helper'

RSpec.describe "/note", type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let!(:note) { FactoryBot.create(:note, user: user) }
  let(:valid_attributes) { FactoryBot.attributes_for(:note, user: user, city: "Poznań") }
  let(:invalid_attributes) { FactoryBot.attributes_for(:note, user: user, city: "Invalid city") }
  let(:blank_attributes) { FactoryBot.attributes_for(:note, user: user, description: nil) }

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
    before do
      allow(OpenweathermapService)
      .to receive(:call)
      .with("Poznań")
      .and_return({ success: true, temperature: 0.77, wind: 1.34, clouds: 40 })
  
      allow(OpenweathermapService)
      .to receive(:call)
      .with("Invalid city")
      .and_return({ success: false, http_status: "404", alert: "city not found" })
    end

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

      it "does not create a new note with invalid attributes" do
        expect {
          post create_path, params: { note: invalid_attributes }
        }.to change(Note, :count).by(0)
      end

      it "redirects to the root_path with alert with invalid attribues" do
        post create_path, params: { note: invalid_attributes }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "404, city not found, enter valid city name"
      end

      it "does not create a new note with blank attributes" do
        expect {
          post create_path, params: { note: blank_attributes }
        }.to change(Note, :count).by(0)
      end

      it "redirects to the root_path with alert with blank attribues" do
        post create_path, params: { note: blank_attributes }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq "Description can't be blank"
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

  describe "GET /edit" do
    it "render a successful response" do
      get edit_path  params: { note_id: note.id }

      expect(response).to be_successful
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      it "updates the requested note" do
        patch update_path, params: { note_id: note.id, note: valid_attributes }
        note.reload

        expect(note.description).to eq(valid_attributes[:description])
      end

      it "redirects to index with notice" do
        patch update_path, params: { note_id: note.id, note: valid_attributes }
        note.reload

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq "Note successfully updated"
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        patch update_path, params: { note_id: note.id, note: blank_attributes }

        expect(response).to redirect_to(edit_path(note_id: note.id))
        expect(flash[:alert]).to eq "Description can't be blank"
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested note" do
      expect {
        delete destroy_path,  params: { note_id: note.id }
      }.to change(Note, :count).by(-1)
    end

    it "redirects back to index with notice" do
      delete destroy_path,  params: { note_id: note.id }

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq "Note successfully deleted"
    end
  end
end