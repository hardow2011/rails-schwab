class RemoveTransactionsChartCacheFromUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :transactions_chart_cache, :string
  end
end
