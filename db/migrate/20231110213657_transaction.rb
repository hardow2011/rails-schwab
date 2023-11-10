class Transaction < ActiveRecord::Migration[7.1]
  def change
    remove_column :transactions, :user_references, :string
    add_reference :transactions, :user, null: false
  end
end
