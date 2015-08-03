class ApplicationController < ActionController::Base
  OAUTH2_PROVIDER = {
    host: 'http://localhost:3000/',
    app_id: '9502172b1dfa201ebcc37da95384bfca7cea71bcffa2a631be62c02996088657',
    app_secret: 'd5f2cda7c6af32209b2d81c90a82b7a98206277713c213571a6e2df833dd88ae',
    callback: 'http://localhost:3001/oauth/callback'
  }

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :logged_in?, :current_user

  before_action :generate_authorize_link, unless: :logged_in?, except: :callback

  protected

  def logged_in?
    !!session[:oauth2_token]
  end

  def generate_authorize_link
    @authorize_link = oauth2_client.auth_code.authorize_url(redirect_uri: OAUTH2_PROVIDER[:callback], state: request.url)
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new(oauth2_client, session[:oauth2_token]) if logged_in?
  end

  def current_user
    @current_user ||= OpenStruct.new(JSON.parse(access_token.get('api/show_user.json').body)) if logged_in?
  end
end
