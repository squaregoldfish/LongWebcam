class CreateCamerasEvents < ActiveRecord::Migration
  def self.up
    create_table :cameras_events, {:id => false} do |t|
      t.integer :camera_id
      t.integer :event_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cameras_events
  end
end
