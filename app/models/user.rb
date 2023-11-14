# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :transactions

  include TransactionsBuilder

  def get_transactions_chart_data
    chart_data = []
    last_transactions_by_date = transactions.order(:created_at).group_by(&:date).transform_values(&:first).values.reverse
    last_transactions_by_date.each_with_index do |t, i|
      next_t = last_transactions_by_date[i+1]
      chart_data << t.as_json(:chart_data)
      if next_t
        days_between_next_transaction = (next_t.date - t.date).to_i - 1
        if days_between_next_transaction >= 1
          new_day = t
          (0..days_between_next_transaction-1).each_with_index do |_, k|
            new_day.date = new_day.date.next_day(k+1)
            chart_data << new_day.as_json(:chart_data)
            new_day.date = t.date
          end
        end
      end
    end
    chart_data
  end

end
