class Api::User
  include Virtus.model

  attribute :email, String
  attribute :access_token, String

  delegate :get, to: :access_token

  def tasks(reload = false)
    @tasks = nil if reload

    @tasks ||= JSON.parse(get('api/tasks.json').body).map do |task_attrs|
      Api::Task.new task_attrs.merge(user: self)
    end
  end
end
