class AddDespatchedToUserCol < ActiveRecord::Migration
  def self.up
      add_column :messages, :despatched_to_user, :boolean, {:null => false, :default => 0}
  end

  def self.down
      remove_column :messages, :despatched_to_user
  end
end
