# frozen_string_literal: true

class FakeTelegramClient
  def initialize(auth_token:)
    @auth_token = auth_token
  end

  def send_message(chat_id:, text:)
    Rails.logger.info("[FakeTelegramClient] Sending message to chat \"#{chat_id}\": #{text}")
  end
end
