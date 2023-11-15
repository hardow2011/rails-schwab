class AddTransactionsChartCacheToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :transactions_chart_cache, :string
  end
end
