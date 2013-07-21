class AddMessageTypeCode < ActiveRecord::Migration
  def self.up
      add_column :message_types, :code, :string, {:null => false}
      add_index :message_types, :code, {:name => "message_types_code_idx", :unique => true}
  end

  def self.down
      remove_index :message_types, :message_types_code_idx
      remove_column :message_types, :code
  end
end
