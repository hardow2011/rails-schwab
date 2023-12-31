module MagicLink
  def send_magic_link(redirect_path)
    generate_login_token
    UserMailer.magic_link(self, login_link(redirect_path)).deliver_later
  end

  def request_email_change
    generate_email_change_token
    UserMailer.request_email_change(self, request_email_change_link).deliver_later
  end

  def update_email(new_email)
    generate_email_change_token(new_email)
    UserMailer.update_email(new_email, update_email_link).deliver_later
  end

  def request_destroy
    generate_user_destroy_token
    UserMailer.request_destroy(self, request_user_destroy_link).deliver_later
  end

  def generate_login_token
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    self.login_token = generate_token(payload)
    save!
  end

  def generate_email_change_token(new_email = nil)
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    payload[:new_email] = new_email if new_email
    self.email_change_token = generate_token(payload)
    save!
  end

  def generate_user_destroy_token
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    self.destroy_token = generate_token(payload)
    save!
  end

  def login_link(redirect_path)
    Rails.application.routes.url_helpers.sessions_url(
      login_token: login_token,
      redirect_path: redirect_path)
  end

  def request_email_change_link
    Rails.application.routes.url_helpers.change_email_url(
      email_change_token: email_change_token
    )
  end

  def update_email_link
    Rails.application.routes.url_helpers.confirm_email_update_url(
      email_update_token: email_change_token
    )
  end

  def request_user_destroy_link
    Rails.application.routes.url_helpers.process_user_destroy_request_url(
      user_destroy_token: destroy_token
    )
  end

  def generate_auth_token
    self.login_token = nil
    self.login_token_verified_at = Time.now
    self.save

    payload = {
      user_id: id,
      login_token_verified_at: login_token_verified_at,
      current_email: self.email,
      exp: 1.day.from_now.to_i
    }

    generate_token(payload)
  end

  private

  def generate_token(token_payload)
    JsonWebToken.encode(token_payload)
  end
end