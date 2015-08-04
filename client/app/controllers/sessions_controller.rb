class SessionsController < ApplicationController
  def callback
    if params[:error] && params[:error] == 'access_denied'
      render plain: params[:error_description]
    else
      token = oauth2_client.auth_code.get_token(params[:code], redirect_uri: OAUTH2_PROVIDER[:callback])

      save_token_info token

      if params[:state] && (return_to_uri = decode_data(params[:state])[:return_to_uri]) =~ URI::ABS_URI
        redirect_to return_to_uri
      else
        # Display the generated token, for debugging purposes only (could optionally redirect to a default page).
        render plain: token.token
      end
    end
  end

  def logout
    reset_token_info

    redirect_to :back
  end
end
