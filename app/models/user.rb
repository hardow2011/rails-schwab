# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :string
#  login_token             :string
#  login_token_verified_at :datetime
#  password_digest         :string
#  transactions            :json
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP, confirmation: { case_sensitive: false }
  validates :password_digest, presence: true

  include TransactionsBuilder
end
