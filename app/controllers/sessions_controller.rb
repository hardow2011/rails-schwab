class SessionsController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create]

  def create
    login_token = params[:login_token]
    redirect_path = params[:redirect_path] || root_path

    decoded_token = JsonWebToken.decode(login_token)

    if decoded_token && JsonWebToken.valid_payload(decoded_token.first)
      user = User.find_by(login_token: login_token)
      if user
        # If user is unregistered, that is, signing up. Then registered it
        unless user.registered?
          user.registered = true
          user.save
        end
        session[:auth_token] = user.generate_auth_token
        redirect_to redirect_path
      else
        flash[:alert] = ['Email not registered']
        redirect_to root_path
      end
    else
      flash[:alert] = ['Invalid token']
      redirect_to root_path
    end
  end

  def change_email
    email_change_token = params[:email_change_token]
    decoded_token = JsonWebToken.decode(email_change_token)

    # Check that decoded_token.first['new_email'].nil? to confirm that the...
    # token is meant to request an email change and not update it yet
    if decoded_token && decoded_token.first['new_email'].nil? && JsonWebToken.valid_payload(decoded_token.first)
      render 'users/change_email', locals: { email_change_token: email_change_token }
    else
      flash[:alert] = ['Expired or Invalid session']
      redirect_to root_path
    end
  end

  def destroy
    session[:auth_token] = nil
    @current_user.logout!
    redirect_to login_path
  end
end
