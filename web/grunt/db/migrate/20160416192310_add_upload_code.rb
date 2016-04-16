class AddUploadCode < ActiveRecord::Migration
  def change
    add_column :cameras, :upload_code, :string, :limit => 4
  end
end
