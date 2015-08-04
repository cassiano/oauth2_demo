class Api::User < Api::Base
  attribute :email, String

  def tasks(reload = false)
    @tasks = nil if reload

    @tasks ||= load_resource('api/tasks.json').map do |task_attrs|
      Api::Task.new task_attrs.merge(user: self)
    end
  end
end
