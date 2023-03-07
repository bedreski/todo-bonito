# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  describe 'PATCH /users/:user_id/tasks/:task_id/complete' do
    let(:task) { create(:task) }

    context 'when task exists' do
      let(:sms_client) { instance_double(FakeSmsClient, send_sms: nil) }
      let(:telegram_client) { instance_double(FakeTelegramClient, send_message: nil) }
      let(:whatsapp_client) { instance_double(FakeWhatsappClient, send_message: nil) }

      let(:expected_sms_client_send_sms_args) do
        {
          from: ENV.fetch('FAKE_SMS_PHONE_NUMBER'),
          to: task.user.phone_number,
          body: "Task \"#{task.name}\" completed!"
        }
      end

      let(:expected_telegram_client_send_message_args) do
        {
          chat_id: task.user.telegram_chat_id,
          text: "Task \"#{task.name}\" completed!"
        }
      end

      let(:expected_whatsapp_client_send_message_args) do
        {
          from: "whatsapp:#{ENV.fetch('FAKE_WHATSAPP_PHONE_NUMBER')}",
          to: "whatsapp:#{task.user.phone_number}",
          body: "Task \"#{task.name}\" completed!"
        }
      end

      before do
        allow(FakeSmsClient).to receive(:new).with(
          account_id: ENV.fetch('FAKE_SMS_ACCOUNT_ID'),
          auth_token: ENV.fetch('FAKE_SMS_AUTH_TOKEN')
        ).and_return(sms_client)
        allow(FakeTelegramClient).to receive(:new).with(
          auth_token: ENV.fetch('FAKE_TELEGRAM_AUTH_TOKEN')
        ).and_return(telegram_client)
        allow(FakeWhatsappClient).to receive(:new).with(
          account_id: ENV.fetch('FAKE_WHATSAPP_ACCOUNT_ID'),
          auth_token: ENV.fetch('FAKE_WHATSAPP_AUTH_TOKEN')
        ).and_return(whatsapp_client)
      end

      it 'responds with 200 (:ok)' do
        patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

        expect(response).to have_http_status(:ok)
      end

      it 'marks task as completed' do
        expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
          .to change { task.reload.completed? }.from(false).to(true)
          .and change { task.reload.completed_at }.from(nil).to(be_present)
      end

      it 'returns updated task in the response' do
        patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

        updated_task = task.reload
        expect(JSON.parse(response.body)).to eq(
          'id' => updated_task.id,
          'userId' => updated_task.user.id,
          'status' => updated_task.status,
          'name' => updated_task.name,
          'createdAt' => updated_task.created_at.as_json,
          'completedAt' => updated_task.completed_at.as_json
        )
      end

      context 'when user has notification enabled to email, SMS, Telegram and Whatsapp' do
        let(:user) { create(:user, notification_preferences: { task_completed: %i[email sms telegram whatsapp] }) }
        let(:task) { create(:task, user:) }

        it 'sends a notification via email' do
          expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'sends a notification via SMS' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(sms_client).to have_received(:send_sms).with(expected_sms_client_send_sms_args)
        end

        it 'sends a notification via Telegram' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(telegram_client).to have_received(:send_message).with(expected_telegram_client_send_message_args)
        end

        it 'sends a notification via Whatsapp' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(whatsapp_client).to have_received(:send_message).with(expected_whatsapp_client_send_message_args)
        end
      end

      context 'when user has notification enabled to email, SMS and Telegram only' do
        let(:user) { create(:user, notification_preferences: { task_completed: %i[email sms telegram] }) }
        let(:task) { create(:task, user:) }

        it 'sends a notification via email' do
          expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'sends a notification via SMS' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(sms_client).to have_received(:send_sms).with(expected_sms_client_send_sms_args)
        end

        it 'sends a notification via Telegram' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(telegram_client).to have_received(:send_message).with(expected_telegram_client_send_message_args)
        end

        it 'does not send a notification via Whatsapp' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(whatsapp_client).not_to have_received(:send_message)
        end
      end

      context 'when user has notification enabled to email, SMS and Whatsapp only' do
        let(:user) { create(:user, notification_preferences: { task_completed: %i[email sms whatsapp] }) }
        let(:task) { create(:task, user:) }

        it 'sends a notification via email' do
          expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'sends a notification via SMS' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(sms_client).to have_received(:send_sms).with(expected_sms_client_send_sms_args)
        end

        it 'does not send a notification via Telegram' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(telegram_client).not_to have_received(:send_message)
        end

        it 'sends a notification via Whatsapp' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(whatsapp_client).to have_received(:send_message).with(expected_whatsapp_client_send_message_args)
        end
      end

      context 'when user has notification enabled to email, Telegram and Whatsapp only' do
        let(:user) { create(:user, notification_preferences: { task_completed: %i[email telegram whatsapp] }) }
        let(:task) { create(:task, user:) }

        it 'sends a notification via email' do
          expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
            .to change { ActionMailer::Base.deliveries.count }.by(1)
        end

        it 'does not send a notification via SMS' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(sms_client).not_to have_received(:send_sms)
        end

        it 'sends a notification via Telegram' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(telegram_client).to have_received(:send_message).with(expected_telegram_client_send_message_args)
        end

        it 'sends a notification via Whatsapp' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(whatsapp_client).to have_received(:send_message).with(expected_whatsapp_client_send_message_args)
        end
      end

      context 'when user has notification disabled' do
        let(:user) { create(:user, notification_preferences: { task_completed: [] }) }
        let(:task) { create(:task, user:) }

        it 'does not send a notification via email' do
          expect { patch("/users/#{task.user.id}/tasks/#{task.id}/complete") }
            .not_to(change { ActionMailer::Base.deliveries.count })
        end

        it 'does not send a notification via SMS' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(sms_client).not_to have_received(:send_sms)
        end

        it 'does not send a notification via Telegram' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(telegram_client).not_to have_received(:send_message)
        end

        it 'does not send a notification via Whatsapp' do
          patch("/users/#{task.user.id}/tasks/#{task.id}/complete")

          expect(whatsapp_client).not_to have_received(:send_message)
        end
      end
    end

    context 'when task does not exist' do
      it 'responds with 404 (:not_found)' do
        patch("/users/#{task.user.id}/tasks/0/complete")

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error details in the response' do
        patch("/users/#{task.user.id}/tasks/0/complete")

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end

    context 'when user does not exist' do
      it 'responds with 404 (:not_found)' do
        patch('/users/0/tasks/0/complete')

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error details in the response' do
        patch('/users/0/tasks/0/complete')

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end
  end
end
