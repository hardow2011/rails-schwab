class AuthenticationController < ApplicationController
  skip_before_action :require_login, only: [:create]

  def create
    user = User.find_or_create_by(email: params[:email])
    user.send_magic_link
  end
end