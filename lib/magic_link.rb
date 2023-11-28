module MagicLink
  def send_magic_link
    generate_login_token
    # if self.new_record?
    # end
    UserMailer.magic_link(self, login_link).deliver_now
  end

  def generate_login_token
    payload = {
      email: email,
      exp: 1.hour.from_now.to_i
    }
    self.login_token = generate_token(payload)
    save!
  end

  def login_link
    Rails.application.routes.url_helpers.sessions_url(
      login_token: login_token,
      host: 'localhost:3000')
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