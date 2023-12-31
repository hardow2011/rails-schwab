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

  def request_email_change(user, email_change_request_link)
    @user = user
    @email_change_request_link = email_change_request_link
    subject = 'Request to change email'

    mail to: @user.email, subject: subject
  end

  def update_email(new_email, update_email_link)
    @update_email_link = update_email_link
    @new_email = new_email
    subject = 'Confirm email change'
    mail to: new_email, subject: subject
  end

  def request_destroy(user, request_user_destroy_link)
    @user = user
    @request_user_destroy_link = request_user_destroy_link

    subject = 'User Deletion Request'
    mail to: @user.email, subject: subject
  end
end
