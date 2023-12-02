class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request!, only: [:create]

  def create
    commit = params[:commit]

    # TODO: finish auth case when
    case commit
    when 'Log In'
      user = User.find_by(email: params[:email])
      if not user
        flash[:error] = 'Email not registered'
        redirect_to login_path
      else
        user.send_magic_link
      end
    when 'Sign up'
      user = User.new(email: params[:email])

    end
  end
end
