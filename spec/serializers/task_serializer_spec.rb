require 'rails_helper'

RSpec.describe 'Task Serializer' do
  let(:user) { create(:user) }
  let(:task) do
      create(:task,
        user: user,
        id: 1,
        name: 'nome',
        status: 'pending', 
        created_at: 2.days.ago, 
        completed_at: Date.today
      )
  end

  let(:task_response) do 
    {
      user: user,
      name: 'nome',
      status: 'pending', 
      created_at: 2.days.ago, 
      completed_at: Date.today
    }
  end
  
  it 'returns serialized task' do
    expect(TaskSerializer.new(:task).as_json).to eq(:task_response)
  end
end
