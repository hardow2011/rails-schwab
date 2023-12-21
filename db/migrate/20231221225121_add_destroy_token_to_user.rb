class AddDestroyTokenToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :destroy_token, :string
  end
end
