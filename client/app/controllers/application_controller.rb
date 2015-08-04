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

  helper_method :logged_in?, :current_user, :authorize_url

  protected

  def logged_in?
    !!current_user
  end

  def authorize_url
    oauth2_client.auth_code.authorize_url(redirect_uri: OAUTH2_PROVIDER[:callback], state: request.url)
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.new(oauth2_client, session[:oauth2_token]) if session[:oauth2_token]
  end

  def current_user
    if session[:oauth2_token]
      begin
        @current_user ||= Api::User.new(Api::Base.parse_json_response(access_token.get('api/whoami.json')).merge(access_token: access_token))
      rescue OAuth2::Error
        session[:oauth2_token] = nil
      end
    end
  end
end
