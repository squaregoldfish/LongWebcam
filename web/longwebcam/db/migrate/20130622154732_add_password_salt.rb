class AddPasswordSalt < ActiveRecord::Migration
  def self.up
      # Add a password salt field to the users table
      add_column :users, :password_salt, :string, {:null => false}
  end

  def self.down
      remove_column :users, :password_salt
  end
end
