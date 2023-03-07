# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all

    serialized_users = users.map do |user|
      {
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'phoneNumber' => user.phone_number,
        'telegramChatId' => user.telegram_chat_id,
        'notificationPreferences' => user.notification_preferences
      }
    end

    render(json: serialized_users)
  end

  def create
    user = User.new(create_user_params)

    if user.save
      serialized_user = {
        'id' => user.id,
        'name' => user.name,
        'email' => user.email,
        'phoneNumber' => user.phone_number,
        'telegramChatId' => user.telegram_chat_id,
        'notificationPreferences' => user.notification_preferences
      }

      render(status: :created, json: serialized_user)
    else
      serialized_error = {
        'error' => {
          'message' => 'Validation error',
          'details' => user.errors.full_messages
        }
      }

      render(status: :unprocessable_entity, json: serialized_error)
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :email, :phone_number, :telegram_chat_id, notification_preferences: {})
  end
end
