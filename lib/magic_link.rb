module MagicLink
  # TODO: make email execute in background job
  def send_magic_link(redirect_path)
    generate_login_token
    UserMailer.magic_link(self, login_link(redirect_path)).deliver_now
  end

  def request_email_change
    generate_email_change_token
    UserMailer.request_email_change(self, request_email_change_link).deliver_now
  end

  def update_email(new_email)
    generate_email_change_token(new_email)
    UserMailer.update_email(self, update_email_link).deliver_now
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

  def generate_auth_token
    self.login_token = nil
    self.login_token_verified_at = Time.now
    self.save

    payload = {
      user_id: id,
      login_token_verified_at: login_token_verified_at,
      exp: 1.day.from_now.to_i
    }

    generate_token(payload)
  end

  private

  def generate_token(token_payload)
    JsonWebToken.encode(token_payload)
  end
end