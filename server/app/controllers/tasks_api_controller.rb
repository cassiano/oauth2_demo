class TasksApiController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def index
    respond_with current_user.tasks
  end
end
