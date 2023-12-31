# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  destroy_token           :string
#  email                   :string
#  email_change_token      :string
#  login_token             :string
#  login_token_verified_at :datetime
#  registered              :boolean          default(FALSE)
#  transactions            :json
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP, confirmation: { case_sensitive: false }
  before_save { self.email = email.strip }

  include TransactionsBuilder
  include MagicLink

  scope :registered, -> { where(registered: true) }
  scope :unregistered, -> { where(registered: false) }

  def logout!
    self.login_token = nil
    self.login_token_verified_at = nil
    save!
  end

  def registered?
    registered
  end

  def confirm_email_update(new_email)
    self.email = new_email
    self.email_change_token = nil
    save!
  end

  def destroy_user!
    self.destroy!
  end

  def self.email_taken?(email)
    !!User.find_by(email: email)
  end
end
