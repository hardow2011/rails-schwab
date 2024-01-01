class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.date :date
      t.references :transaction_type, null: false, foreign_key: true
      t.string :user_references
      t.string :description
      t.float :withdrawal
      t.float :deposit
      t.float :running_balance

      t.timestamps
    end
  end
end
