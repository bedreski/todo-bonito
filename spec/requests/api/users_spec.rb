require 'swagger_helper'

RSpec.describe 'Users', type: :request do
  path '/users' do
    get 'List all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              email: { type: :string },
              phoneNumber: { type: :string },
              telegramChatId: { type: :string },
              notificationPreferences: {
                type: :object,
                properties: {
                  task_completed: {
                    type: :array,
                    items: { type: :string, enum: %w[email sms telegram whatsapp] }
                  }
                }
              }
            }
          }

        run_test!
      end
    end

    post 'Create a user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          phone_number: { type: :string },
          telegram_chat_id: { type: :string },
          notification_preferences: {
            type: :object,
            properties: {
              task_completed: {
                type: :array,
                items: { type: :string, enum: %w[email sms telegram whatsapp] }
              }
            }
          }
        },
        required: %w[name email phone_number telegram_chat_id notification_preferences],
        example: {
          name: 'Monica Geller',
          email: 'monica@geller.com',
          phone_number: '+123456789',
          telegram_chat_id: '123456789',
          notification_preferences: {
            task_completed: %w[email sms telegram whatsapp]
          }
        }
      }


      response '201', 'user created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            name: { type: :string },
            email: { type: :string },
            phoneNumber: { type: :string },
            telegramChatId: { type: :string },
            notificationPreferences: {
              type: :object,
              properties: {
                task_completed: {
                  type: :array,
                  items: { type: :string, enum: %w[email sms telegram whatsapp] }
                }
              }
            }
          }

        let(:user) do
          {
            name: 'Monica Geller',
            email: 'monica@geller.com',
            phone_number: '+123456789',
            telegram_chat_id: '123456789',
            notification_preferences: {
              task_completed: %w[email sms telegram whatsapp]
            }
          }
        end

        run_test!
      end

      response '422', 'unprocessable entity' do
        schema type: :object,
          properties: {
            error: {
              type: :object,
              properties: {
                message: { type: :string },
                details: { type: :array, items: { type: :string } }
              }
            }
          }

        let(:user) { { name: '' } }

        run_test!
      end
    end
  end
end
