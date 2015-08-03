class Task
  include Virtus.model

  attribute :title, String
  attribute :due_date, DateTime
end
