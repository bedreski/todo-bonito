# frozen_string_literal: true

class FakeSmsClient
  def initialize(account_id:, auth_token:)
    @account_id = account_id
    @auth_token = auth_token
  end

  def send_sms(from:, to:, body:)
    Rails.logger.info("[FakeSmsClient] Sending message from \"#{from}\" to \"#{to}\": #{body}")
  end
end
