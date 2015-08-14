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

  def encode_data(object)
    Base64.encode64({ data: object }.to_json)
  end

  def decode_data(text)
    JSON.parse(Base64.decode64(text), symbolize_names: true)[:data]
  end

  def authorize_url(return_to_uri = request.url)
    oauth2_client.auth_code.authorize_url redirect_uri: OAUTH2_PROVIDER[:callback],
                                          state: encode_data(return_to: return_to_uri)
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token(reload = false)
    @access_token = nil if reload

    @access_token ||= OAuth2::AccessToken.from_hash(oauth2_client, session[:oauth2_token].dup) if session[:oauth2_token]
  end

  def save_token_in_session(token)
    session[:oauth2_token] = token && token.to_hash

    access_token true   # Forces the access token to be reloaded from the session data.
  end

  def reset_token_info
    save_token_in_session nil
  end

  def save_token_info(token)
    save_token_in_session token
  end

  def refresh_token
    new_token = access_token.refresh!

    save_token_info new_token
  end

  def current_user
    if access_token
      begin
        refresh_token if access_token.expired?

        @current_user ||= Api::User.from_token(access_token)
      rescue OAuth2::Error
        reset_token_info
      end
    end
  end
end
