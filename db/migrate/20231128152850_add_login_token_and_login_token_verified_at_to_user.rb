class AddLoginTokenAndLoginTokenVerifiedAtToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :login_token, :string
    add_column :users, :login_token_verified_at, :datetime
  end
end
