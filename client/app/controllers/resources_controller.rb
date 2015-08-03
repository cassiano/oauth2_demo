class ResourcesController < ApplicationController
  def show
    if logged_in?
      @tasks = JSON.parse(access_token.get('api/tasks.json').body).map do |task|
        task['due_date'] = DateTime.parse(task['due_date']) if task['due_date']

        OpenStruct.new task
      end
    end
  end
end
