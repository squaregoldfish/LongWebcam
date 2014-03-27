class CreateEventTags < ActiveRecord::Migration
  def self.up
    create_table :event_tags do |t|
      t.string :tag
      t.integer :parent

      t.timestamps
    end
  end

  def self.down
    drop_table :event_tags
  end
end
