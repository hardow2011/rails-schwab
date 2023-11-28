class UserMailer < ApplicationMailer
  def magic_link(user, login_link)
    @user = user
    @login_link = login_link
    mail to: @user.email, subject: 'Log In to...'
  end
end
