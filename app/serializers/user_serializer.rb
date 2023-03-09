class UserSerializer 
  def initialize(user)
    @user = user 
  end
  
  def as_json
    {
      'id' => user.id,
      'name' => user.name,
      'email' => user.email,
      'phoneNumber' => user.phone_number,
      'telegramChatId' => user.telegram_chat_id,
      'notificationPreferences' => user.notification_preferences
    } 
  end 

  private 

  attr_reader :user
end 
