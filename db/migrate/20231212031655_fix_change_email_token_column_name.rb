class FixChangeEmailTokenColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :change_email_token, :email_change_token
  end
end
