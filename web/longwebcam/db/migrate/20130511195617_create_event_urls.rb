class CreateEventUrls < ActiveRecord::Migration
  def self.up
    create_table :event_urls do |t|
      t.string :title
      t.string :url
      t.boolean :accessible
      t.date :last_check_date
      t.date :last_access_date
      t.string :archive_url

      t.timestamps
    end
  end

  def self.down
    drop_table :event_urls
  end
end
