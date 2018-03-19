require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:question) { FactoryBot.create(:question, :with_two_answers) }
  let(:user) { FactoryBot.create(:user) }
  let(:answer) { question.answers.first }
  let!(:vote) { FactoryBot.create(:vote, user: user, question: question, answer:question.answers.first)}
  it "has a valid factory" do
    #FactoryBot.create(:vote, question: question, answer: question.answers.first, user: user)
    comment = FactoryBot.build(:comment, question: question, answer: question.answers.first, user: user)
    comment.valid?
    expect(comment).to be_valid
  end

  it "is valid with 200 characters or less content" do
    content = 'a'* 200
    comment = FactoryBot.build(:comment, content: content, question: question, answer: question.answers.first, user: user)
    comment.valid?
    expect(comment).to be_valid
  end

  it "is invalid with more than 200 characters content" do
    content = 'a' * 201
    comment = FactoryBot.build(:comment, content: content, question: question, answer: question.answers.first, user: user)
    comment.valid?
    expect(comment.errors[:content]).to include("は200文字以内で入力してください")
  end

  it "is invalid without a content" do
    comment = FactoryBot.build(:comment, content: nil, question: question, answer: question.answers.first, user: user)
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end

  #　質問に属する回答以外の回答をつかってコメント
  it "is invlaid with a invalid (question_id, answer_id) pair" do
    q = FactoryBot.create(:question, :with_two_answers)
    comment = FactoryBot.build(:comment, question: question, answer: q.answers.first, user: user)
    comment.valid?
    expect(comment.errors[:answer]).to include("不正なコメントです")
  end

  #
  it "is invalid with a (user_id, question_id) pair which does'nt exist in votes" do
    q = FactoryBot.create(:question, :with_two_answers)
    comment = FactoryBot.build(:comment, question: q, answer: q.answers.first, user: user)
    comment.valid?
    expect(comment.errors[:user]).to include("コメントは投票しないとできません")
  end

end
