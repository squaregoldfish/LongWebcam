class CreateCamerasTags < ActiveRecord::Migration
  def self.up
    create_table :cameras_tags, {:id => false} do |t|
      t.integer :camera_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cameras_tags
  end
end
