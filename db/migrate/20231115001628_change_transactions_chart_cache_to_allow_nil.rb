class ChangeTransactionsChartCacheToAllowNil < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :transactions_chart_cache, true
  end
end
