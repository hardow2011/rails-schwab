class ChangeTransactionsDefaultValue < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :transactions, :json, default: []
  end
end
