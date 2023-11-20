class SessionsController < ApplicationController
  def new
    redirect_to root_path if session[:user_id]
    @failed_login = session[:failed_login]
    session[:failed_login] = nil
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
