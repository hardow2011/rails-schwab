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
  setup do
    @test_csv_path = 'test/fixtures/files/test_csv.csv'
  end

  test "should not save user without email" do
    user = User.new(password: 'mypassword')
    assert_not user.save, 'Saved the user without an email'
  end

  test "should not save user with invalid email" do
    user = User.new(email: 'invemail.com')
    user.save
    assert_includes user.errors[:email], 'is invalid', 'Saved the user with an invalid email'
  end

  test "should not save user without password" do
    user = User.new(email: 'deo@njode.com')
    assert_not user.save, 'Saved the user without a password'
  end

  test "transactions csv should set correct amount of transactions" do
    csv = File.open(@test_csv_path)
    user = users(:one)
    user.set_transactions(csv)
    assert_equal 64, user.transactions.size, 'Transaction csv should have created 64 transactions'
  end

end
