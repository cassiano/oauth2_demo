class ApplicationController < ActionController::Base
  OAUTH2_PROVIDER = {
    host: 'http://localhost:3000/',
    app_id: '8c1020d7adfaaf927a34ee7cc95b5bf76dc24462a41263b234eb8853c529aa6a',
    app_secret: '67a25c354f05e2a9cfb435cca7c75f2bdad417a8bcc559875f987ed81b4f2f6c',
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
      state: encode_data({ return_to: request.url })
    )
  end

  def oauth2_client
    @oauth2_client ||= OAuth2::Client.new(OAUTH2_PROVIDER[:app_id], OAUTH2_PROVIDER[:app_secret], site: OAUTH2_PROVIDER[:host])
  end

  def access_token
    @access_token ||= OAuth2::AccessToken.from_hash oauth2_client, session[:oauth2_token].dup if session[:oauth2_token]
  end

  def reset_token_info
    @access_token = nil    # Reset the access token's memoization instance variable.

    session[:oauth2_token] = nil
  end

  def save_token_info(token)
    @access_token = nil    # Reset the access token's memoization instance variable.

    session[:oauth2_token] = token.to_hash
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
