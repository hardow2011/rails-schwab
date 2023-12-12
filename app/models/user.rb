# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  change_email_token      :string
#  email                   :string
#  login_token             :string
#  login_token_verified_at :datetime
#  registered              :boolean          default(FALSE)
#  transactions            :json
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# TODO: Allow user to update email
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP, confirmation: { case_sensitive: false }

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

  def self.email_taken?(email)
    !!User.find_by(email: email)
  end
end
