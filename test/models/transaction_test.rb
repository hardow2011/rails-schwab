# == Schema Information
#
# Table name: transactions
#
#  id                  :bigint           not null, primary key
#  date                :date
#  deposit             :float
#  description         :string
#  running_balance     :float
#  withdrawal          :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  transaction_type_id :bigint           not null
#  user_id             :bigint           not null
#
# Indexes
#
#  index_transactions_on_transaction_type_id  (transaction_type_id)
#  index_transactions_on_user_id              (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (transaction_type_id => transaction_types.id)
#
require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
