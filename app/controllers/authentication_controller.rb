class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create]

  def create
    commit = params[:commit]
    redirect_path = params[:redirect_path]

    # TODO: make user wait before attempting another login/signup
    # TODO: refactor this case/when
    case commit
    when 'Log In'
      user = User.registered.find_by(email: params[:email])
      if not user
        flash[:errors] = ['Email not registered']
        redirect_to login_path
      else
        user.send_magic_link(redirect_path)
        flash[:success] = ["Login email sent. Please check your inbox"]
        redirect_to login_path
      end
    when 'Sign up'
      user = User.registered.find_by(email: params[:email])
      if user
        flash[:errors] = ['Email already taken']
        redirect_to signup_path
      else
        user = User.find_or_create_by(email: params[:email])
        user.send_magic_link(redirect_path)
        flash[:success] = ["Signup email sent. Please check your inbox"]
        redirect_to login_path
      end
    end
  end
end
