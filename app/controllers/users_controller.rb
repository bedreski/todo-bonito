# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all
    serialized_users = users.map { |user| UserSerializer.new(user).as_json }
    render(json: serialized_users)
  end

  def create
    user = User.new(create_user_params)
    serialized_user = UserSerializer.new(user).as_json
    serialized_error = ValidationErrorSerializer.new(user.errors.full_messages).as_json

    if user.save
      render(status: :created, json: serialized_user)
    else
      render(status: :unprocessable_entity, json: serialized_error)
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :email, :phone_number, :telegram_chat_id, notification_preferences: {})
  end
end
