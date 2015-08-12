class Api::User < Api::Base
  attribute :email, String

  def self.from_token(access_token)
    new access_token.get('api/v1/users/whoami.json').parsed.merge(access_token: access_token)
  end

  def tasks(reload = false)
    @tasks = nil if reload

    @tasks ||= load_resource('api/v1/tasks.json').map do |task_attrs|
      Api::Task.new task_attrs.merge(user: self)
    end
  end
end
