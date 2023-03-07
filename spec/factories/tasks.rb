# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    user
    sequence(:name) { |n| "Task #{n}" }
    status { :pending }

    trait :completed do
      status { :completed }
      completed_at { Time.current }
    end
  end
end
