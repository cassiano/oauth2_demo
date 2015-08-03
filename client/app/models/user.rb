class User
  include Virtus.model

  attribute :email, String

  attr_reader :access_token

  delegate :get, to: :access_token

  def initialize(attrs, access_token)
    @access_token = access_token

    super attrs
  end

  def tasks
    @tasks ||= JSON.parse(get('api/tasks.json').body).map do |task_attrs|
      Task.new task_attrs
    end
  end
end
