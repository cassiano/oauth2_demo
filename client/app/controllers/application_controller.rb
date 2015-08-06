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

  def authorize_url
    oauth2_client.auth_code.authorize_url(
      redirect_uri: OAUTH2_PROVIDER[:callback],
      state: encode_data({ return_to_uri: request.url })
    )
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token
    if session[:oauth2_token]
      @access_token ||= begin
        token_info = HashWithIndifferentAccess.new(session[:oauth2_token])

        OAuth2::AccessToken.new(
          oauth2_client,
          token_info[:access_token],
          refresh_token: token_info[:refresh_token],
          expires_at: token_info[:expires_at]
        )
      end
    end
  end

  def reset_token_info
    @access_token = nil

    session[:oauth2_token] = nil
  end

  def save_token_info(token)
    @access_token = nil

    session[:oauth2_token] = {
      access_token: token.token,
      refresh_token: token.refresh_token,
      expires_at: token.expires_at
    }
  end

  def refresh_token
    new_token = access_token.refresh!

    save_token_info new_token
  end

  def current_user
    if access_token
      begin
        refresh_token if access_token.expired?

        @current_user ||= Api::User.new(access_token.get('api/whoami.json').parsed.merge(access_token: access_token))
      rescue OAuth2::Error
        reset_token_info
      end
    end
  end
end
