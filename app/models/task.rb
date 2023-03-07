# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  enum status: { pending: 'pending', completed: 'completed' }

  validates :user, presence: true
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validates :name, presence: true
end
