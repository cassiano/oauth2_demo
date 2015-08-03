class TasksController < ApplicationController
  def show
    if logged_in?
      @tasks = JSON.parse(access_token.get('api/tasks.json').body).map do |task_attrs|
        Task.new task_attrs
      end
    end
  end
end
