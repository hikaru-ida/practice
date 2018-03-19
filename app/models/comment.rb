class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :question
  belongs_to :answer

  default_scope -> {order(created_at: :desc)}
  validates :content, presence: true, length: { maximum: 200 }
  validate :validate_question_answer_pair
  validate :validate_user_question_pair

  paginates_per 10

  def validate_question_answer_pair
    if !question.answers.include?(answer)
      errors.add(:answer, "不正なコメントです")
    end
  end

  # 未投票の場合コメントできない
  def validate_user_question_pair
    if !Vote.find_by(question_id: question.id, user_id: user.id)
      errors.add(:user, "コメントは投票しないとできません")
    end
  end
end
