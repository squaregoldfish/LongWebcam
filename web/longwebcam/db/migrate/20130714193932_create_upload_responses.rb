class CreateUploadResponses < ActiveRecord::Migration
  def self.up

      # Create the table that holds the codes and messages for
      # image upload responses
      #
      create_table :upload_responses do |t|
          t.integer :code, {:null => false}
          t.string :message, {:null => false}
      end

      add_index :upload_responses, :code, {:name => "uploadresponses_code_idx", :unique => true}
  end

  def self.down
      remove_index :upload_responses, :uploadresponses_code_idx
      drop_table :upload_responses
  end
end
