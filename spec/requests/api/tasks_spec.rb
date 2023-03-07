require 'swagger_helper'

RSpec.describe 'Tasks', type: :request do
  path '/users/{user_id}/tasks' do
    get 'Retrieves all tasks' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, required: true, example: 1

      response '200', 'tasks found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              userId: { type: :integer },
              status: { type: :string },
              name: { type: :string },
              completedAt: { type: :string, format: :date_time, nullable: true },
            }
          }

          let(:user_id) { create(:user).id }

          run_test!
      end

      response '404', 'not found' do
        schema type: :object,
          properties: {
            error: {
              type: :object,
              properties: {
                message: { type: :string },
              }
            }
          }

        let(:user_id) { 0 }

        run_test!
      end
    end

    post 'Creates a task' do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :user_id, in: :path, type: :string, required: true, example: 1
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: %w[name],
        example: {
          name: 'Buy coffee'
        }
      }

      response '201', 'task created' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            userId: { type: :integer },
            status: { type: :string },
            name: { type: :string },
            completedAt: { type: :string, format: :date_time, nullable: true },
          }

        let(:user_id) { create(:user).id }
        let(:task) { { name: 'Buy coffee' } }

        run_test!
      end

      response '404', 'not found' do
        schema type: :object,
          properties: {
            error: {
              type: :object,
              properties: {
                message: { type: :string },
              }
            }
          }

        let(:user_id) { 0 }
        let(:task) { { name: 'Buy coffee' } }

        run_test!
      end

      response '422', 'unprocessable entity' do
        schema type: :object,
          properties: {
            error: {
              type: :object,
              properties: {
                message: { type: :string },
                details: { type: :array, items: { type: :string } }
              }
            }
          }

        let(:user_id) { create(:user).id }
        let(:task) { { name: '' } }

        run_test!
      end
    end

    path '/users/{user_id}/tasks/{id}' do
      get 'Retrieves a task' do
        tags 'Tasks'
        consumes 'application/json'
        parameter name: :user_id, in: :path, type: :string, required: true, example: 1
        parameter name: :id, in: :path, type: :string, required: true, example: 1

        response '200', 'task found' do
          schema type: :object,
            properties: {
              id: { type: :integer },
              userId: { type: :integer },
              status: { type: :string },
              name: { type: :string },
              completedAt: { type: :string, format: :date_time, nullable: true },
            }

          let(:task) { create(:task) }
          let(:user_id) { task.user_id }
          let(:id) { task.id }

          run_test!
        end

        response '404', 'not found' do
          schema type: :object,
            properties: {
              error: {
                type: :object,
                properties: {
                  message: { type: :string },
                }
              }
            }

          let(:user_id) { create(:user).id }
          let(:id) { 0 }

          run_test!
        end
      end
    end

    path '/users/{user_id}/tasks/{id}/complete' do
      patch 'Completes a task' do
        tags 'Tasks'
        consumes 'application/json'
        parameter name: :user_id, in: :path, type: :string, required: true, example: 1
        parameter name: :id, in: :path, type: :string, required: true, example: 1

        response '200', 'task completed' do
          schema type: :object,
            properties: {
              id: { type: :integer },
              userId: { type: :integer },
              status: { type: :string },
              name: { type: :string },
              completedAt: { type: :string, format: :date_time, nullable: true },
            }

          let(:task) { create(:task) }
          let(:user_id) { task.user_id }
          let(:id) { task.id }

          run_test!
        end

        response '404', 'not found' do
          schema type: :object,
            properties: {
              error: {
                type: :object,
                properties: {
                  message: { type: :string },
                }
              }
            }

          let(:user_id) { create(:user).id }
          let(:id) { 0 }

          run_test!
        end
      end
    end
  end
end
