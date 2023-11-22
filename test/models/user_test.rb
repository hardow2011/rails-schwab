# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  transactions    :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should not save user without email" do
    user = User.new
    assert_not user.save, 'Saved the user without an email'
  end
end
