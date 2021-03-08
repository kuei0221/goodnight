FactoryBot.define do
  factory :sleep do
    association :user

    trait :recorded do
      start_at { Time.now }
      end_at { Time.now + 8.hour }
    end
  end
end
