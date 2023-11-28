module MagicLink
  def send_magic_link
    UserMailer.magic_link(self, login_link).deliver_now
  end
end