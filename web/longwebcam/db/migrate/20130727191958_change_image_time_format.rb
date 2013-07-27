class ChangeImageTimeFormat < ActiveRecord::Migration
  def self.up

      # For ease of coding, change the time stamps to complete DateTime
      # fields instead of just times. Having complete timestamps will
      # make data storage and parsing easier 
      change_column :images, :image_time, :datetime
      change_column :images, :weather_time, :datetime
  end

  def self.down
      change_column :images, :image_time, :time
      change_column :images, :weather_time, :time
  end
end
