class AddTimezoneIdFields < ActiveRecord::Migration
  def self.up
      add_column :camera_details, :timezone_id, :string, {:null => true}
      add_index :camera_details, :timezone_id, {:name => "camera_details_timzoneid_idx"}

      add_column :images, :image_timezone_id, :string
      add_column :images, :weather_timezine_id, :string
  end

  def self.down
      remove_column :camera_details, :timezone_id
      remove_index :camera_details, :camera_details_timzoneid_idx

      remove_column :images, :image_timezone_id
      remove_column :images, :weather_timezone_id
  end
end
