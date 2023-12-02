class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create]

  def create
    commit = params[:commit]

    case commit
    when 'Log In'
      user = User.registered.find_by(email: params[:email])
      if not user
        flash[:errors] = ['Email not registered']
        redirect_to login_path
      else
        user.send_magic_link
      end
    # TODO: what happens if user tries to register twice?
    when 'Sign up'
      user = User.registered.find_by(email: params[:email])
      if user
        flash[:errors] = ['Email already taken']
        redirect_to signup_path
      else
        user.send_magic_link(true)
      end
    end
  end
end
