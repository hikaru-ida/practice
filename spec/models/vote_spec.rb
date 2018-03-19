require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:question) { FactoryBot.create(:question, :with_two_answers) }
  let(:user) { FactoryBot.create(:user) }
  it "has a valid factory" do
    vote = FactoryBot.build(:vote, user: user, question: question, answer: question.answers.first)
    vote.valid?
    expect(vote).to be_valid
  end

  it "is invalid with a duplicate (user_id, question_id) pair" do
    FactoryBot.create(:vote, user: user, question: question, answer: question.answers.first)
    vote = FactoryBot.build(:vote, user: user, question: question, answer: question.answers.first)
    vote.valid?
    expect(vote.errors[:question]).to include("すでに投票しています")
  end

  it "is invalid with a invalid (question_id, answer_id) pair" do
    question2 = FactoryBot.create(:question, :with_two_answers)
    vote = FactoryBot.build(:vote, question: question, answer: question2.answers.first)
    vote.valid?
    expect(vote.errors[:answer]).to include("不正な投票です")
  end
end
