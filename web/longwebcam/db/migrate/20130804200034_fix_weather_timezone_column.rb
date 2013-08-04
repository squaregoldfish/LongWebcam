class FixWeatherTimezoneColumn < ActiveRecord::Migration
  def self.up
      rename_column :images, :weather_timezine_id, :weather_timezone_id
  end

  def self.down
      rename_column :images, :weather_timezone_id, :weather_timezine_id
  end
end
