# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    users = User.all
    render(json: users.map { |user| UserSerializer.new(user).as_json })
  end

  def create
    user = User.new(create_user_params)

    if user.save
      render(status: :created, json: UserSerializer.new(user).as_json)
    else
      render(status: :unprocessable_entity, json: ValidationErrorSerializer.new(user.errors.full_messages).as_json)
    end
  end

  private

  def create_user_params
    params.require(:user).permit(:name, :email, :phone_number, :telegram_chat_id, notification_preferences: {})
  end
end
