require 'rails_helper'
RSpec.describe Question, type: :model do
  it "has a valid factory" do
    question = FactoryBot.build(:question, :with_two_answers)
    question.valid?
    expect(question).to be_valid
  end

  describe "content" do
    it "is valid with contents not more than 100 characters" do
      content = 'a'* 100
      question = FactoryBot.build(:question, :with_two_answers, content: content)
      question.valid?
      expect(question).to be_valid
    end

    it "is invalid with contents more than 100 characters" do
      content = 'a'*101
      question = FactoryBot.build(:question, :with_two_answers, content: content)
      question.valid?
      expect(question.errors[:content]).to include("は100文字以内で入力してください")
    end

    it "is invalid with empty contents" do
      content = ""
      question = FactoryBot.build(:question, :with_two_answers, content: content)
      question.valid?
      expect(question.errors[:content]).to include("を入力してください")
    end
  end

  describe "description" do
    it "is valid with 500 characters or less description" do
      description = 'a' * 500
      question = FactoryBot.build(:question, :with_two_answers, description: description)
      question.valid?
      expect(question).to be_valid
    end


    it "is invalid with more than 500 characters description" do
      description = 'a' * 501
      question = FactoryBot.build(:question, :with_two_answers, description: description)
      question.valid?
      expect(question.errors[:description]).to include("は500文字以内で入力してください")
    end

    it "is valid with empty description" do
      description = ""
      question = FactoryBot.build(:question, :with_two_answers, description: description)
      question.valid?
      expect(question).to be_valid
    end

  end

  describe "answers" do
    it "is invalid with too many answers" do
      question = FactoryBot.build(:question, :with_five_answers)
      question.valid?
      expect(question.errors[:answers]).to include("は4つ以下にしてください。")
    end

    it "is invalid with too few answers" do
      question = FactoryBot.build(:question, :with_one_answer)
      question.valid?
      expect(question.errors[:answers]).to include("は2つ以上入力してください。")
    end

    it "is invalid with empty answers" do
      question = FactoryBot.build(:question)
      question.answers << FactoryBot.build(:answer, question_id: question.id, content: nil)
      question.answers << FactoryBot.build(:answer, question_id: question.id, content: nil)
      question.valid?
      expect(question.errors["answers.content"]).to include("を入力してください")
    end

    it "is invalid with more than 50 characters answer's content" do
      question = FactoryBot.build(:question)
      answer_content = 'a'*51
      question.answers << FactoryBot.build(:answer, question_id: question.id, content: answer_content)
      question.answers << FactoryBot.build(:answer, question_id: question.id, content: answer_content)
      question.valid?
      expect(question.errors["answers.content"]).to include("は50文字以内で入力してください")
    end

  end

end