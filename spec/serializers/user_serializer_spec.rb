require 'rails_helper'

RSpec.describe 'User Serializer' do
  
  let(:user) do
    create(
      :user, 
      name: 'nome', 
      email: 'nome@email.com', 
      phone_number: '+00000000', 
      telegram_chat_id: '1', 
      notification_preferences: {
        'task_completed': [
          'sms', 
          'telegram', 
          'whatsapp'
        ]
      }
    ) 
  end 

  let(:user_response) do
    {
      'id' => user.id,
      'name' => 'nome',
      'email' => 'nome@email.com',
      'phoneNumber' => '+00000000',
      'telegramChatId' => '1',
      'notificationPreferences' => user.notification_preferences
    } 
  end 

  it 'returns serialized user' do
    expect(UserSerializer.new(user).as_json).to eq(user_response) 
  end 
end 
