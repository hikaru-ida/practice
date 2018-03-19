FactoryBot.define do
  factory :comment do
    sequence(:content)  { |n| "これは#{n}番目のコメントです" }
    association :question
    association :user
    association :answer
  end
end
