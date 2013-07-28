class TzOffsetsToSeconds < ActiveRecord::Migration
  def self.up
      # Change the way timezone offsets are stored from hours and minutes
      # to seconds, to make offset calculations shorter
      remove_column :camera_details, :utc_offset_hour
      remove_column :camera_details, :utc_offset_minute
      add_column :camera_details, :utc_offset, :integer

      remove_column :images, :image_time_offset_hour
      remove_column :images, :image_time_offset_minute
      remove_column :images, :weather_time_offset_hour
      remove_column :images, :weather_time_offset_minute

      add_column :images, :image_time_offset, :integer
      add_column :images, :weather_time_offset, :integer
  end

  def self.down
      add_column :camera_details, :utc_offset_hour
      add_column :camera_details, :utc_offset_minute
      remove_column :camera_details, :utc_offset, :integer

      add_column :images, :image_time_offset_hour
      add_column :images, :image_time_offset_minute
      add_column :images, :weather_time_offset_hour
      add_column :images, :weather_time_offset_minute

      remove_column :images, :image_time_offset, :integer
      remove_column :images, :weather_time_offset, :integer
  end
end
