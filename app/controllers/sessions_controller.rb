class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :redirect_to_root_of_logged_in, only: [:new]

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:failed_login] = nil
      session[:user_id] = @user.id
      redirect_to root_path
    else
      session[:failed_login] = true
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
