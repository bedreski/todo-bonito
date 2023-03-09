class TaskSerializer 
  def initialize(task)
    @task = task 
  end

  def as_json
    {
      'id' => task.id,
      'userId' => task.user_id,
      'status' => task.status,
      'name' => task.name,
      'createdAt' => task.created_at,
      'completedAt' => task.completed_at
    } 
  end 

  private 

  attr_reader :task
end 
