
class ApplicationController < ActionController::Base
  OAUTH2_PROVIDER = Rails.application.secrets.oauth.deep_symbolize_keys
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user, :authorize_link

  protected

  def logged_in?
    !!session[:oauth2_token]
  end

  def authorize_link
    oauth2_client.auth_code.authorize_url(redirect_uri: OAUTH2_PROVIDER[:callback], state: request.url)
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new(oauth2_client, session[:oauth2_token]) if logged_in?
  end

  def current_user
    @current_user ||= Api::User.new(JSON.parse(access_token.get('api/whoami.json').body).merge(access_token: access_token)) if logged_in?
  end
end
