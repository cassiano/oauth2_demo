class UsersApiController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def show
    respond_with current_user
  end
end
