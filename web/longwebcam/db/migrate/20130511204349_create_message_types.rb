class CreateMessageTypes < ActiveRecord::Migration
  def self.up
    create_table :message_types do |t|
      t.string :subject
      t.text :text

      t.timestamps
    end
  end

  def self.down
    drop_table :message_types
  end
end
