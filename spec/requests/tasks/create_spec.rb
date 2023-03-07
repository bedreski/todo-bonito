# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks' do
  describe 'POST /users/:user_id/tasks' do
    let(:user) { create(:user) }
    let(:params) do
      {
        task: {
          name: 'Task name'
        }
      }
    end

    context 'when params are valid' do
      it 'responds with 201 (:created)' do
        post("/users/#{user.id}/tasks", params:)

        expect(response).to have_http_status(:created)
      end

      it 'creates a new pending task' do
        expect { post("/users/#{user.id}/tasks", params:) }.to change { user.tasks.pending.count }.by(1)
      end

      it 'returns the new task in the response' do
        post("/users/#{user.id}/tasks", params:)

        new_task = user.tasks.last
        expect(JSON.parse(response.body)).to eq(
          'id' => new_task.id,
          'userId' => user.id,
          'status' => new_task.status,
          'name' => new_task.name,
          'createdAt' => new_task.created_at.as_json,
          'completedAt' => new_task.completed_at
        )
      end
    end

    context 'when user does not exist' do
      it 'responds with 402 (:not_found)' do
        post('/users/0/tasks', params:)

        expect(response).to have_http_status(:not_found)
      end

      it 'does not create a new task' do
        expect { post('/users/0/tasks', params:) }.not_to change(Task, :count)
      end

      it 'returns a error details in the response' do
        post('/users/0/tasks', params:)

        expect(JSON.parse(response.body)).to include('error' => { 'message' => 'Not found' })
      end
    end

    context 'when name is invalid' do
      let(:params) do
        {
          task: {
            name: ''
          }
        }
      end

      it 'responds with 422 (:unprocessable_entity)' do
        post("/users/#{user.id}/tasks", params:)

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new task' do
        expect { post("/users/#{user.id}/tasks", params:) }.not_to change(Task, :count)
      end

      it 'returns a error details in the response' do
        post("/users/#{user.id}/tasks", params:)

        expect(JSON.parse(response.body)).to include(
          'error' => include('message' => 'Validation error', 'details' => ["Name can't be blank"])
        )
      end
    end
  end
end
