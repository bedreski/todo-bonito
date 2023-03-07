# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  describe 'GET /users/:user_id/tasks/:task_id' do
    let(:task) { create(:task) }

    context 'when task exists' do
      it 'responds with 200 (:ok)' do
        get("/users/#{task.user.id}/tasks/#{task.id}")

        expect(response).to have_http_status(:ok)
      end

      it 'returns task in the response' do
        get("/users/#{task.user.id}/tasks/#{task.id}")

        expect(JSON.parse(response.body)).to eq(
          'id' => task.id,
          'userId' => task.user.id,
          'status' => task.status,
          'name' => task.name,
          'createdAt' => task.created_at.as_json,
          'completedAt' => task.completed_at.as_json
        )
      end
    end

    context 'when task does not exist' do
      it 'responds with 404 (:not_found)' do
        get("/users/#{task.user.id}/tasks/0")

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error details in the response' do
        get("/users/#{task.user.id}/tasks/0")

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end

    context 'when user does not exist' do
      it 'responds with 404 (:not_found)' do
        get('/users/0/tasks/0')

        expect(response).to have_http_status(:not_found)
      end

      it 'returns a error details in the response' do
        get('/users/0/tasks/0')

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end
  end
end
