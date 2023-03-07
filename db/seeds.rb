# frozen_string_literal: true

user = User.create!(
  name: 'Phoebe Buffay',
  email: 'phoebe@buffay.com',
  phone_number: '+1111111111',
  telegram_chat_id: 'phoebe-buffay',
  notification_preferences: { task_completed: %i[email sms telegram whatsapp] }
)
user.tasks.create!(name: 'Record Smelly Cat', status: :pending)

user = User.create!(
  name: 'Chandler Bing',
  email: 'chandler@bing.com',
  phone_number: '+2222222222',
  telegram_chat_id: 'chandler-bing',
  notification_preferences: { task_completed: %i[sms whatsapp] }
)
user.tasks.create!(name: 'Feed the duck', status: :pending)

user = User.create!(
  name: 'Joey Tribbiani',
  email: 'joey@tribbiani.com',
  phone_number: '+3333333333',
  telegram_chat_id: 'joey-tribbiani',
  notification_preferences: { task_completed: [] }
)
user.tasks.create!(name: 'Feed the chick', status: :pending)
