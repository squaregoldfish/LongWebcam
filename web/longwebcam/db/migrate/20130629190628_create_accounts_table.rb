class CreateAccountsTable < ActiveRecord::Migration
  def self.up
      create_table :accounts do |t|
          t.string :account, {:null => false}
          t.string :username
          t.string :password
          t.string :api_key
      end

      add_index :accounts, :account, {:name => "accounts_account_idx", :unique => true}
  end

  def self.down
      remove_index :accounts, :accounts_account_idx
      drop_table :accounts
  end
end
