# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :phone_number, presence: true, uniqueness: true
  validates :telegram_chat_id, presence: true, uniqueness: true
  validates :notification_preferences, presence: true
  validate :notification_preferences_cannot_include_invalid_types
  validate :notification_preferences_cannot_include_invalid_channels

  private

  def notification_preferences_cannot_include_invalid_types
    return if (notification_preferences || {}).keys.all? { |key| %w[task_completed].include?(key) }

    errors.add(:notification_preferences, 'contains invalid notification type')
  end

  def notification_preferences_cannot_include_invalid_channels
    return if (notification_preferences || {}).values.flatten.all? do |value|
                %w[email sms telegram whatsapp].include?(value)
              end

    errors.add(:notification_preferences, 'contains invalid notification channel')
  end
end
