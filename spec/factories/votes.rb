FactoryBot.define do
  factory :vote do
    association :user
    association :question
    association :answer
  end
end
