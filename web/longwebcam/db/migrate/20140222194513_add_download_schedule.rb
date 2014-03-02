class AddDownloadSchedule < ActiveRecord::Migration
  # Add download schedule hours to the cameras table
  def self.up
      # Remove the schedule column - not sure what it was for
      remove_column :cameras, :schedule

      # Add columns for download time limits
      add_column :camera_details, :download_start, :integer, {:default => 10}
      add_column :camera_details, :download_end, :integer, {:default => 14}
  end

  def self.down
      remove_column :camera_details, :download_start
      remove_column :camera_details, :download_end

      add_column :cameras, :schedule, :integer
  end
end
