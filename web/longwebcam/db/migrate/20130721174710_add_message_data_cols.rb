class AddMessageDataCols < ActiveRecord::Migration
  def self.up
      # New columns for the messages table
      #
      # A column that says whether or not a message should
      # ever be despatched to a user
      add_column :messages, :can_despatch, :boolean, {:default => 0}

      # Columns for message data beyond what is in the message template
      # (as stored in the message_type table)
      add_column :messages, :extra_text, :string, {:null => true}
      add_column :messages, :extra_data, :binary, {:null => true}
  end

  def self.down
      remove_column :messages, :can_despatch
      remove_column :messages, :extra_text
      remove_column :messages, :extra_data
  end
end
