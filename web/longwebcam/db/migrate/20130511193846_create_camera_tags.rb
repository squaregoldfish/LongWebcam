class CreateCameraTags < ActiveRecord::Migration
  def self.up
    create_table :camera_tags do |t|
      t.string :tag
      t.integer :parent

      t.timestamps
    end
  end

  def self.down
    drop_table :camera_tags
  end
end
