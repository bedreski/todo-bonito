# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'GET /users' do
    let!(:users) { create_list(:user, 3) }

    it 'responds with 200 (:ok)' do
      get('/users')

      expect(response).to have_http_status(:ok)
    end

    it 'returns users in the response' do
      get('/users')

      expect(JSON.parse(response.body))
        .to eq(
          users.map do |user|
            {
              'id' => user.id,
              'name' => user.name,
              'email' => user.email,
              'phoneNumber' => user.phone_number,
              'telegramChatId' => user.telegram_chat_id,
              'notificationPreferences' => user.notification_preferences
            }
          end
        )
    end
  end
end
