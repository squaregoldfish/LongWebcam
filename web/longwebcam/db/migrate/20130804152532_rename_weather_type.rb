class RenameWeatherType < ActiveRecord::Migration
  def self.up
      rename_column :images, :weather_type, :weather_code
  end

  def self.down
      rename_column :images, :weather_code, :weather_code
  end
end
