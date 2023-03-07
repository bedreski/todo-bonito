# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/MethodLength
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone_number, null: false
      t.string :telegram_chat_id, null: false
      t.json :notification_preferences, null: false

      t.index :email, unique: true
      t.index :phone_number, unique: true
      t.index :telegram_chat_id, unique: true

      t.timestamps
    end
  end
end
