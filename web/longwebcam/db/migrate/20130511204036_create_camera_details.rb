class CreateCameraDetails < ActiveRecord::Migration
  def self.up
    create_table :camera_details do |t|
      t.integer :camera_id
      t.date :details_date
      t.float :longitude
      t.float :latitude
      t.integer :bearing
      t.integer :ground_height
      t.integer :camera_height
      t.string :manufacturer
      t.string :model
      t.integer :resolution_x
      t.integer :resolution_y

      t.timestamps
    end
  end

  def self.down
    drop_table :camera_details
  end
end
