class ApplicationController < ActionController::Base
  helper_method :logged_in?, :current_user
  before_action :require_login

  def current_user
    user_id = session[:user_id]
    if user_id
      User.find(user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def require_login
    redirect_to login_path unless logged_in?
  end
end
