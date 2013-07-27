class FixImageFieldnames < ActiveRecord::Migration
  def self.up
    # Correct field name
    rename_column :images, :image_time_offeet_hour, :image_time_offset_hour
  end

  def self.down
    rename_column :images, :image_time_offset_hour, :image_time_offeet_hour
  end
end
