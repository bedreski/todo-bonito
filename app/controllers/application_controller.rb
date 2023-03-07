# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  private

  def record_not_found
    serialized_error = {
      'error' => {
        'message' => 'Not found'
      }
    }

    render(status: :not_found, json: serialized_error)
  end
end
