class Tag < ApplicationRecord
  has_and_belongs_to_many :questions
  validates :name, length: {maximum: 50}

  def self.order_of_popularity(num)
    joins(:questions)
    .group('questions_tags.tag_id')
    .order('count_questions_tags_tag_id desc')
    .limit(num)
    .count('questions_tags.tag_id')
    .keys
  end
end
