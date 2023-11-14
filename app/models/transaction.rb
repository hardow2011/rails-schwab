# == Schema Information
#
# Table name: transactions
#
#  id                  :bigint           not null, primary key
#  date                :date
#  deposit             :float
#  description         :string
#  running_balance     :float
#  user_references     :string
#  withdrawal          :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  transaction_type_id :bigint           not null
#
# Indexes
#
#  index_transactions_on_transaction_type_id  (transaction_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (transaction_type_id => transaction_types.id)
#
class Transaction < ApplicationRecord
  belongs_to :transaction_type
  belongs_to :user

  def as_json(options={})
    if options == :chart_data
      {
        date: date,
        running_balance: running_balance
      }
    end
  end
end
