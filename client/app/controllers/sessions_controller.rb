class SessionsController < ApplicationController
  def callback
    oauth2_token           = oauth2_client.auth_code.get_token(params[:code], redirect_uri: OAUTH2_PROVIDER[:callback])
    session[:oauth2_token] = oauth2_token.token

    if params[:state]
      redirect_to params[:state]
    else
      # Display the generated token, for debugging purposes only (could optionally redirect to a default page).
      render plain: oauth2_token.token
    end
  end

  def logout
    session[:oauth2_token] = nil

    redirect_to :back
  end
end
