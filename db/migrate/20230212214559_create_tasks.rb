# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :status, null: false
      t.timestamp :completed_at

      t.timestamps
    end
  end
end
