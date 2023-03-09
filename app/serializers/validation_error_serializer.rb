class ValidationErrorSerializer
  def initialize(errors)
    @errors = errors
  end 

  def as_json 
    {
      'error' => {
        'message' => 'Validation error', 
        'details' => errors
      }
    }
  end 

  private

  attr_reader :errors
end 
