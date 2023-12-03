class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create]

  def create
    login_token = params[:login_token]
    decoded_token = JsonWebToken.decode(login_token)

    if decoded_token && JsonWebToken.valid_payload(decoded_token.first)
      user = User.find_by(login_token: login_token)
      if user
        # If user is unregistered, that is, signing up, then registered it
        unless user.registered?
          user.registered = true
          user.save
        end
          session[:auth_token] = user.generate_auth_token
          redirect_to root_path
      # TODO: add else
      end
    end
  end

  def destroy
    session[:auth_token] = nil
    @current_user.logout!
    redirect_to login_path
  end
end
