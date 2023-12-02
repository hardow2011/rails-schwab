# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  email                   :string
#  login_token             :string
#  login_token_verified_at :datetime
#  registered              :boolean          default(FALSE)
#  transactions            :json
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
require "test_helper"

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  setup do
    @test_csv_path = 'test/fixtures/files/test_csv.csv'
    @test_csv_2_path = 'test/fixtures/files/test_csv_2.csv'
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

  test "second transactions csv should overwrite first transactions csv" do
    csv_1 = File.open(@test_csv_path)
    csv_2 = File.open(@test_csv_2_path)
    user = users(:one)

    user.set_transactions(csv_1)
    assert_equal 64, user.transactions.size, 'First transaction csv should have created 64 transactions'

    user.set_transactions(csv_2)
    assert_equal 24, user.transactions.size, 'Second transaction csv should have overwritten transactions to 24'
  end

  test "transactions chart data should return a correct amount of days " do
    csv_1 = File.open(@test_csv_path)
    csv_2 = File.open(@test_csv_2_path)
    user = users(:one)

    user.set_transactions(csv_1)
    assert_equal 43, JSON.parse(user.get_transactions_chart_data).size, 'First transactions csv should have returned a chart data of 43 days'

    user.set_transactions(csv_2)
    assert_equal 22, JSON.parse(user.get_transactions_chart_data).size, 'Second transactions csv should have returned a chart data of 22 days'
  end

end
