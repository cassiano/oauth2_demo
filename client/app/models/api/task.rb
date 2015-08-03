class Api::Task
  include Virtus.model

  attribute :title, String
  attribute :due_date, DateTime
  attribute :user, Api::User
end
