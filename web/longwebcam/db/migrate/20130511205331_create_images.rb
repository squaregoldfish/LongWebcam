class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images, {:id => false} do |t|
      t.integer :camera_id
      t.date :date
      t.integer :image_present, :limit => 1
      t.time :image_time
      t.integer :image_time_offeet_hour
      t.integer :image_time_offset_minute
      t.time :weather_time
      t.integer :weather_time_offset_hour
      t.integer :weather_time_offset_minute
      t.integer :temperature
      t.integer :weather_type
      t.integer :wind_speed
      t.integer :wind_bearing
      t.float :rain
      t.float :visibility
      t.integer :pressure
      t.integer :cloud_cover
      t.integer :air_quality

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
