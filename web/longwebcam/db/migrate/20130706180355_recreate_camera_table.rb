class RecreateCameraTable < ActiveRecord::Migration
  def self.up
      execute "DROP TABLE IF EXISTS `cameras`" 

      create_table :cameras do |t|
        t.integer :owner, {:null => false}
        t.integer :camera_type, {:null => false}
        t.string :url
        t.string :serial_number
        t.boolean :test_camera
        t.string :licence
        t.string :upload_code, :limit => 4
        t.boolean :watermark

        t.timestamps
      end
  end

  def self.down
      drop_table :cameras
  end
end
