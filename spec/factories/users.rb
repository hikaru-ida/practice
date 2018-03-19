FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "testuser#{n}" }
    sequence(:email) { |n| "tester#{n}@example.com"}
    password "foobar"
  end
end
