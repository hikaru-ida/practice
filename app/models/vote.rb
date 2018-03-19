class Vote < ApplicationRecord
  belongs_to :question
  belongs_to :user
  belongs_to :answer
  default_scope -> { order(created_at: :desc)}
  validates :question, uniqueness: { scope: :user,
    message: "すでに投票しています"}
  validate :validate_question_answer_pair
  paginates_per 20

  def validate_question_answer_pair
    if !question.answers.include?(answer)
      errors.add(:answer, "不正な投票です")
    end
  end

end
