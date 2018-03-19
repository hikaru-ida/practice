class Question < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :answers, reject_if: :reject_answers, allow_destroy: true
  validates :content, presence: true, length: { maximum: 100 }
  validates :answers, length: {
    maximum: 4,
    minimum: 2,
    too_short: "は2つ以上入力してください。",
    too_long: "は4つ以下にしてください。"
  }
  #validate :validate_answers_size

  validates :description, length: { maximum: 500 }


  def validate_answers_size
    errors.add(:answers, "回答数が少なすぎます。") if answers.size < 2
  end

  def reject_answers(attributes)
    attributes['content'].blank?
  end

  # javascriptに渡す用のchart.jsのパラメータを返す
  def create_chart_params
    chart_params = {}
    chart_params["labels"] = answers.map {|answer| answer["content"]}
    chart_params["values"] = answers.map {|answer| answer["vote_count"]}
    chart_params.to_json.html_safe
  end


  #
  after_create do
    question = Question.find_by(id: self.id)
    hashtags = self.description.scan(/[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtag|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      question.tags << tag
    end
  end

  before_update do
    question = Question.find_by(id: self.id)
    question.tags.clear
    hashtags = self.description.scan(/[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー]+/)
    hashtags.uniq.map do |hashtags|
      tag = Tag.find_or_create_by(name: hashtag.downcase.delete('#'))
      question.tags << tag
    end
  end
end
