class AddChangeEmailTokenToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :change_email_token, :string
  end
end
