# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  before { create(:user, :with_tasks) }

  describe 'GET /users/:user_id/tasks' do
    context 'when user has tasks' do
      let(:user) { create(:user, :with_tasks) }

      it 'responds with 200 (:ok)' do
        get("/users/#{user.id}/tasks")

        expect(response).to have_http_status(:ok)
      end

      it 'returns user tasks in the response' do
        get("/users/#{user.id}/tasks")

        expect(JSON.parse(response.body))
          .to eq(
            user.tasks.map do |task|
              {
                'id' => task.id,
                'userId' => user.id,
                'status' => task.status,
                'name' => task.name,
                'createdAt' => task.created_at.as_json,
                'completedAt' => task.completed_at.as_json
              }
            end
          )
      end
    end

    context 'when user does not have tasks' do
      let(:user) { create(:user) }

      it 'responds with 200 (:ok)' do
        get("/users/#{user.id}/tasks")

        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array in the response' do
        get("/users/#{user.id}/tasks")

        expect(JSON.parse(response.body)).to eq([])
      end
    end

    context 'when user does not exist' do
      it 'responds with 404 (:not_found)' do
        get('/users/0/tasks')

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error details in the response' do
        get('/users/0/tasks')

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end
  end
end
