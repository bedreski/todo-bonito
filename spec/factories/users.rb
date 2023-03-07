# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    sequence(:phone_number, &:to_s)
    sequence(:telegram_chat_id, &:to_s)
    notification_preferences { { task_completed: %i[sms telegram whatsapp] } }

    trait :with_tasks do
      transient do
        tasks_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:task, evaluator.tasks_count, :user)
      end
    end
  end
end
