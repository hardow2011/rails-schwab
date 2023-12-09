module MagicLink
  # TODO: make email execute in background job
  def send_magic_link(redirect_path)
    generate_login_token
    UserMailer.magic_link(self, login_link(redirect_path)).deliver_now
  end

  def generate_login_token
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    self.login_token = generate_token(payload)
    save!
  end

  def login_link(redirect_path)
    Rails.application.routes.url_helpers.sessions_url(
      login_token: login_token,
      redirect_path: redirect_path)
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