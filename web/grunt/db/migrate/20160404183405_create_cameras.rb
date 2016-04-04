class CreateCameras < ActiveRecord::Migration
  def change
    create_table :cameras do |t|
        t.integer :camera_id, {:null => false}
        t.datetime :retrieved, {:null => false}
        t.string :timezone_id, {:null => false}
        t.boolean :daylight_saving, {:default => 1}
        t.integer :utc_offset, {:null => false}
        t.integer :download_start, {:default => 10}
        t.integer :download_end, {:default => 14}
        t.string :url, {:null => false}
    end
  end
end
