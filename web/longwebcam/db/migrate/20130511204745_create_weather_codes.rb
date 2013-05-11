class CreateWeatherCodes < ActiveRecord::Migration
  def self.up
    create_table :weather_codes, {:id => false} do |t|
      t.integer :code
      t.string :condition

      t.timestamps
    end
  end

  def self.down
    drop_table :weather_codes
  end
end
