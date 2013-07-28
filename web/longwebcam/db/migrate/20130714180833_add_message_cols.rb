class AddMessageCols < ActiveRecord::Migration
  def self.up
      # Add message content fields to the messages table
      # The extra_data field is new, and the actual message column was
      # missing for some reason.
      add_column :messages, :message, :text, {:null => false}
      add_column :messages, :extra_data, :text
  end

  def self.down
      remove_column :messages, :message
      remove_column :messages, :extra_data
  end
end
