# frozen_string_literal: true

class FakeWhatsappClient
  def initialize(account_id:, auth_token:)
    @account_id = account_id
    @auth_token = auth_token
  end

  def send_message(from:, to:, body:)
    Rails.logger.info("[FakeWhatsappClient] Sending message from \"#{from}\" to \"#{to}\": #{body}")
  end
end
