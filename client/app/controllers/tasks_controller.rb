class TasksController < ApplicationController
  def show
    if logged_in?
      @tasks = JSON.parse(access_token.get('api/tasks.json').body, object_class: OpenStruct).map do |task|
        task.tap do |t|
          t.due_date = DateTime.parse(t.due_date) if t.due_date
        end
      end
    end
  end
end
