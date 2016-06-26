class MakeLongBlob < ActiveRecord::Migration
  def up
    change_column :images, :image_data, :binary, :limit => 10.megabyte
    change_column :messages, :extra_text, :text, :limit => 10.megabyte
    change_column :messages, :extra_data, :binary, :limit => 10.megabyte
  end

  def down
    change_column :images, :image_data, :binary
    change_column :messages, :extra_text, :string
    change_column :messages, :extra_data, :binary
  end
end
