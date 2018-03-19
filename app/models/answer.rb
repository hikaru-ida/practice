class Answer < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :question
  validates :content, presence: true, length: { maximum: 50 }
  #before_create :count_answer
  #validate :count_answer

  default_scope -> {order(id: :asc)}
  def count_answer
    if question
      count = 0
      question.answers.each do |answer|
        if !answer.content.blank?
          count += 1
        end
      end
    end
    if count < 3
      errors.add(:question, "回答の数が足りません")
    end
  end

end
