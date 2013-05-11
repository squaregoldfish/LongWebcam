class CreateEventsUrls < ActiveRecord::Migration
  def self.up
    create_table :events_urls, {:id => false} do |t|
      t.integer :event_id
      t.integer :url_id

      t.timestamps
    end
  end

  def self.down
    drop_table :events_urls
  end
end
