class CreateCameras < ActiveRecord::Migration
  def self.up
    create_table :cameras do |t|
      t.integer :owner
      t.integer :type, :limit => 1 
      t.string :url
      t.string :serial_number
      t.integer :schedule
      t.integer :test_camera, :limit => 1
      t.string :licence
      t.string :upload_code, :limit => 4
      t.integer :watermark, :limit => 1
      t.string :title
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :cameras
  end
end
