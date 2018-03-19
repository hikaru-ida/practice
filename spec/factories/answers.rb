FactoryBot.define do
  factory :answer do
    sequence(:content) { |n| "回答#{n}" }
    association :question
  end
end
