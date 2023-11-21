class AddTransactionsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :transactions, :json
  end
end
