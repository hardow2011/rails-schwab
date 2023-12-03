class UserMailer < ApplicationMailer
  def magic_link(user, login_link)
    @user = user
    @login_link = login_link

    if user.registered?
      subject = 'Log In to...'
      @text = 'Log in'
    else
      subject = 'Sign up to...'
      @text = 'Sign up'
    end

    mail to: @user.email, subject: subject
  end
end
