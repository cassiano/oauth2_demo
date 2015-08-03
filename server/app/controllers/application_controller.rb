class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    return_to_url, session[:return_to] = session[:return_to], nil

    return_to_url
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id)
  end
end
