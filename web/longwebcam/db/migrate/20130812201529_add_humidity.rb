class AddHumidity < ActiveRecord::Migration
  def self.up
      add_column :images, :humidity, :integer
  end

  def self.down
      remove_column :images, :humidity
  end
end
