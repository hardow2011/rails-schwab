class ApplicationController < ActionController::Base
  add_flash_types :errors, :success

  helper_method :logged_in?
  before_action :authenticate_request!

  def redirect_to_root_of_logged_in
    redirect_to root_path if logged_in?
  end

  private

  def authenticate_request!
    original_request = request.fullpath == '/' ? nil : request.fullpath
    auth_token = session[:auth_token]
    if !auth_token
      return invalid_authentication(redirect_path: original_request)
    end

    load_current_user!(auth_token)
    invalid_authentication unless @current_user
  end

  def invalid_authentication(redirect_path: nil)
    redirect_to login_path(redirect_path: redirect_path)
  end

  def payload(auth_token)
    JsonWebToken.decode(auth_token)
  end

  def load_current_user!(auth_token)
    @current_user = User.find_by(id: payload(auth_token)[0]['user_id'])
  end

  def logged_in?
    auth_token = session[:auth_token]
    if !auth_token
      false
    else
      user = User.find_by(id: payload(auth_token)[0]['user_id'])
    end
    !!user
  end
end
