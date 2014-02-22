class AddDownloadSchedule < ActiveRecord::Migration
  # Add download schedule hours to the cameras table
  def self.up
      # Remove the schedule column - not sure what it was for
      remove_column :cameras, :schedule

      # Add columns for download time limits
      add_column :cameras, :download_start, :integer, {:null => false, :default => 10}
      add_column :cameras, :download_end, :integer, {:null => false, :default => 14}
  end

  def self.down
      remove_column :cameras, :download_start
      remove_column :cameras, :download_end

      add_column :cameras, :schedule, :integer
  end
end
