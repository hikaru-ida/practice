require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  describe "#create" do
    context "as an login user" do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, :with_two_answers)}
      it "add a vote" do
        sign_in user
        expect {
          post :create, params: { vote: { question_id: question.id, answer_id: question.answers.first.id, user_id: user.id}}
      }.to change(user.votes, :count).by(1)
      end

      it "redirects to the question page after voting" do
        sign_in user
        post :create, params: { vote: { question_id: question.id, answer_id: question.answers.first.id, user_id: user.id }}
        expect(response).to redirect_to question_path(question)
      end
    end

    context "as a guest" do
      let(:user) { FactoryBot.create(:user) }
      let(:question) { FactoryBot.create(:question, :with_two_answers)}
      it "returns 302 response" do
        post :create, params: { vote: { question_id: question.id, answer_id: question.answers.first.id, user_id: user.id }}
        expect(response).to have_http_status "302"
      end

      it "redirects to sign-in page" do
        post :create, params: { vote: { question_id: question.id, answer_id: question.answers.first.id, user_id: user.id }}
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
