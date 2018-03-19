FactoryBot.define do
  factory :question do
    sequence(:content) { |n| "質問#{n}" }
    description "説明"
    association :user

    trait :with_one_answer do
      after(:build) do |question|
        (0..0).each do
          question.answers << FactoryBot.build(:answer, question: question)
        end
      end
    end

    trait :with_two_answers do
      after(:build) do |question|
        (0..1).each do
          question.answers << FactoryBot.build(:answer, question: question)
        end
      end
    end

    trait :with_four_answers do
      after(:build) do |question|
        (0..3).each do
          question.answers << FactoryBot.build(:answer, question: question)
        end
      end
    end

    trait :with_five_answers do
      after(:build) do |question|
        (0..4).each do
          question.answers << FactoryBot.build(:answer, question: question)
        end
      end
    end

  end
end
