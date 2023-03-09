require 'rails_helper'

RSpec.describe 'Task Serializer' do
  let(:user) { create(:user) }
  let(:task) do
      create(:task,
        user: user,
        name: 'nome',
        status: 'pending', 
        created_at: 2.days.ago, 
        completed_at: Date.today
      )
  end

  let(:task_response) do 
    {
      'userId' => user.id,
      'id' => task.id,
      'name' => 'nome',
      'status' => 'pending', 
      'createdAt' => task.created_at, 
      'completedAt' => task.completed_at
    }
  end
  
  it 'returns serialized task' do
    expect(TaskSerializer.new(task).as_json).to eq(task_response)
  end
end
