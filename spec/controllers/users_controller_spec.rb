require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#user_comments" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      it "responds successfully" do
        sign_in user
        get :user_comments, params: { user_id: user.id }
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      let(:user) { FactoryBot.create(:user)}
      let(:other_user) { FactoryBot.create(:user)}
      it "responds successfully" do
        sign_in other_user
        get :user_comments, params: { user_id: user.id}
        expect(response).to be_success
      end
    end

    context "as a guest" do
      let(:user) { FactoryBot.create(:user)}
      it "responds successfully" do
        get :user_comments, params: { user_id: user.id }
        expect(response).to be_success
      end
    end
  end

  describe "#user_questions" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      it "responds successfully" do
        sign_in user
        get :user_questions, params: { user_id: user.id }
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      let(:user) { FactoryBot.create(:user)}
      let(:other_user) { FactoryBot.create(:user)}
      it "returns 302 response" do
        sign_in other_user
        get :user_questions, params: { user_id: user.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to root url" do
        sign_in other_user
        get :user_questions, params: { user_id: user.id }
        expect(response).to redirect_to root_url
      end
    end

    context "as a guest" do
      let(:user) { FactoryBot.create(:user) }
      it "returns 302 response" do
        get :user_questions, params: { user_id: user.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to sign-in page" do
        get :user_questions, params: { user_id: user.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#user_votes" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      it "responds successfully" do
        sign_in user
        get :user_votes, params: { user_id: user.id }
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      let(:user) { FactoryBot.create(:user)}
      let(:other_user) { FactoryBot.create(:user)}
      it "returns 302 response" do
        sign_in other_user
        get :user_votes, params: { user_id: user.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to root url" do
        sign_in other_user
        get :user_votes, params: { user_id: user.id }
        expect(response).to redirect_to root_url
      end
    end

    context "as a guest" do
      let(:user) { FactoryBot.create(:user)}
      it "returns 302 response" do
        get :user_votes, params: { user_id: user.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to sign-in page" do
        get :user_votes, params: { user_id: user.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end


end
