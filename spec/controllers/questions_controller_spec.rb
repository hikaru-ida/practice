require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe "#index" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user) }
      it "responds successfully" do
        sign_in user
        get :index
        expect(response).to be_success
      end

    end

    context "as a guest" do
      it "responds successfully" do
        get :index
        expect(response).to be_success
      end
    end
  end

  describe "#hashtags" do
    let(:user) { FactoryBot.create(:user)}
    let(:tag) { FactoryBot.create(:tag)}
    context "as an authorized user" do
      it "responds successfully" do
        sign_in user
        get :hashtags, params: { name: tag.name }
        expect(response).to be_success
      end
    end

    context "as a guest" do
      it "responds successfully" do
        get :hashtags, params: { name: tag.name }
        expect(response).to be_success
      end
    end
  end

  describe "#order_of_popularity" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      it "responds successfully" do
        sign_in user
        get :order_of_popularity
        expect(response).to be_success
      end
    end

    context "as a guest" do
      it "responds successfully" do
        get :order_of_popularity
        expect(response).to be_success
      end
    end
  end

  describe "#hashtags_order_of_popularity" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      let(:tag) { FactoryBot.create(:tag)}
      it "responds successfully" do
        sign_in user
        get :hashtags_order_of_popularity, params: { name: tag.name }
        expect(response).to be_success
      end
    end

    context "as a guest" do
      let(:tag) { FactoryBot.create(:tag)}
      it "responds successfully" do
        get :hashtags_order_of_popularity, params: { name: tag.name }
        expect(response).to be_success
      end
    end
  end

  describe "#show" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      it "responds successfully" do
        sign_in user
        get :show, params: { id: question.id }
        expect(response).to be_success
      end

      it "returns a 302 response when question_id is invalid" do
        sign_in user
        get :show, params: { id: question.id+1 }
        expect(response).to have_http_status "302"
      end

      it "redirects to the root page when question_id is invalid" do
        sign_in user
        get :show, params: { id: question.id+1 }
        expect(response).to redirect_to root_path
      end
    end

    context "as a guest" do
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      it "returns a 302 response" do
        get :show, params: { id: question.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        get :show, params: { id: question.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end

  end

  describe "#new" do
    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user) }
      it "responds successfully" do
        sign_in user
        get :new
        expect(response).to be_success
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        get :new
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        get :new
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end


  describe "#create" do
    before do
      @question_params = FactoryBot.attributes_for(:question)
      @question_params[:answers_attributes] = []
      (0..1).each do
        @question_params[:answers_attributes] << FactoryBot.attributes_for(:answer)
      end
    end

    context "as an authorized user" do
      let(:user) { FactoryBot.create(:user)}
      it "adds a question" do
        sign_in user
        expect {
          post :create, params: { question: @question_params }
        }.to change(user.questions, :count).by(1)
      end
    end

    context "as a guest" do
      it "returns a 302 response" do
        post :create, params: { question: @question_params }
        expect(response).to have_http_status "302"
      end

      it "redirects to the sign-in page" do
        post :create, params: { question: @question_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end


end
