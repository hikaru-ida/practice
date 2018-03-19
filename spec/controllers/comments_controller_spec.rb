require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "#index" do
    context "as a login user" do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      let(:comment) { FactoryBot.create(:comment) }
      it "responds successfully" do
        sign_in user
        get :index, params: { question_id: question.id }
        expect(response).to be_success
      end

    end

    context "as a guest" do
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      let(:comment) { FactoryBot.create(:comment) }
      it "returns 302 response" do
        get :index, params: { question_id: question.id }
        expect(response).to have_http_status "302"
      end

      it "redirects to sign-in page" do
        get :index, params: { question_id: question.id }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#create" do
    context "as a login user" do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      it "adds a comment" do
        sign_in user
        #　コメントの前に投票を済ませておく
        vote = FactoryBot.create(:vote, user_id: user.id, question_id: question.id, answer_id: question.answers.first.id)
        
        comment_params = FactoryBot.attributes_for(:comment, question_id: question.id)
        expect {
          post :create, params: { comment: comment_params, question_id: question.id }
        }.to change(user.comments, :count).by(1)
      end
    end

    context "as a guest" do
      let(:question) { FactoryBot.create(:question, :with_two_answers) }
      it "returns 302 response" do
          comment_params = FactoryBot.attributes_for(:comment, question_id: question.id)
          post :create, params: { comment: comment_params, question_id: question.id }
          expect(response).to have_http_status "302"
      end

      it "redirects to sign-in page" do
          comment_params = FactoryBot.attributes_for(:comment, question_id: question.id)
          post :create, params: { comment: comment_params, question_id: question.id }
          expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

end
