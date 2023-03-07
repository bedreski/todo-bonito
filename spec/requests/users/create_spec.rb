# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  describe 'POST /users' do
    let(:params) do
      {
        user: {
          name: 'User name',
          email: 'user@example.com',
          phone_number: '+1234567890',
          telegram_chat_id: '1234567890',
          notification_preferences: { task_completed: %i[sms telegram whatsapp] }
        }
      }
    end

    context 'when params are valid' do
      it 'responds with 201 (:created)' do
        post('/users', params:)

        expect(response).to have_http_status(:created)
      end

      it 'creates a new user' do
        expect { post('/users', params:) }.to change(User, :count).by(1)
      end

      it 'returns the new user in the response' do
        post('/users', params:)

        new_user = User.last
        expect(JSON.parse(response.body)).to eq(
          'id' => new_user.id,
          'name' => new_user.name,
          'email' => new_user.email,
          'phoneNumber' => new_user.phone_number,
          'telegramChatId' => new_user.telegram_chat_id,
          'notificationPreferences' => new_user.notification_preferences
        )
      end
    end

    context 'when name is invalid' do
      let(:params) do
        {
          user: {
            name: '',
            email: 'user@example.com',
            phone_number: '+1234567890',
            telegram_chat_id: '1234567890',
            notification_preferences: { task_completed: %i[sms telegram whatsapp] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Name can't be blank"])
        )
      end
    end

    context 'when email is invalid' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: '',
            phone_number: '+1234567890',
            telegram_chat_id: '1234567890',
            notification_preferences: { task_completed: %i[sms telegram whatsapp] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Email can't be blank"])
        )
      end
    end

    context 'when phone number is invalid' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: 'user@example.com',
            phone_number: '',
            telegram_chat_id: '1234567890',
            notification_preferences: { task_completed: %i[sms telegram whatsapp] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Phone number can't be blank"])
        )
      end
    end

    context 'when telegram chat ID is invalid' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: 'user@example.com',
            phone_number: '+1234567890',
            telegram_chat_id: '',
            notification_preferences: { task_completed: %i[sms telegram whatsapp] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Telegram chat can't be blank"])
        )
      end
    end

    context 'when notification preference is not present' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: 'user@example.com',
            phone_number: '+1234567890',
            telegram_chat_id: '1234567890',
            notification_preferences: nil
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Notification preferences can't be blank"])
        )
      end
    end

    context 'when notification preference contains invalid type' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: 'user@example.com',
            phone_number: '+1234567890',
            telegram_chat_id: '1234567890',
            notification_preferences: { invalid_type: %i[sms telegram whatsapp] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error',
                             'details' => ['Notification preferences contains invalid notification type'])
        )
      end
    end

    context 'when notification preference contains invalid channel' do
      let(:params) do
        {
          user: {
            name: 'User name',
            email: 'user@example.com',
            phone_number: '+1234567890',
            telegram_chat_id: '1234567890',
            notification_preferences: { task_completed: %i[invalid_channel] }
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post('/users', params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new user' do
        expect { post('/users', params:) }.not_to change(User, :count)
      end

      it 'returns a error details in the response' do
        post('/users', params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error',
                             'details' => ['Notification preferences contains invalid notification channel'])
        )
      end
    end
  end
end
