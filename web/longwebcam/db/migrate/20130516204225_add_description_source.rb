class AddDescriptionSource < ActiveRecord::Migration
  def self.up
      # Add description_source column to the events table
      add_column :events, :description_source, :string, {:null => true}
  end

  def self.down
      # Remove the column
      remove_column :events, :description_source
  end
end
