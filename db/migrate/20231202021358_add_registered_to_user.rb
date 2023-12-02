class AddRegisteredToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :registered, :boolean, default: false
  end
end
