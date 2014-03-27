class AddTimezoneToCameraDetails < ActiveRecord::Migration
  def self.up
    add_column :camera_details, :utc_offset_hour, :integer
    add_column :camera_details, :utc_offset_minute, :integer
  end

  def self.down
    remove_column :camera_details, :utc_offset_hour
    remove_column :camera_details, :utc_offset_minute
  end
end
