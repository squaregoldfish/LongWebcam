class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :camera_id
      t.datetime :timestamp
      t.integer :message_type, :limit => 1
      t.integer :read_by_user, :limit => 1
      t.integer :read_by_admin, :limit => 1
      t.integer :resolved, :limit => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
