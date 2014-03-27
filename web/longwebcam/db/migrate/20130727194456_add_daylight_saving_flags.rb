class AddDaylightSavingFlags < ActiveRecord::Migration
  def self.up
    # Add daylight saving flags to timezone info
    add_column :camera_details, :daylight_saving, :boolean, {:null => false}
    add_column :images, :image_daylight_saving, :boolean
    add_column :images, :weather_daylight_saving, :boolean
  end

  def self.down
    remove_column :camera_details, :daylight_saving
    remove_column :images, :image_daylight_saving
    remove_column :images, :weather_daylight_saving
  end
end
