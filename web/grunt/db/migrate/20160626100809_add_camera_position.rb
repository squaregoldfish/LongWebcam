class AddCameraPosition < ActiveRecord::Migration
  def change
    add_column :cameras, :longitude, :float, {:null => false}
    add_column :cameras, :latitude, :float, {:null => false}
  end
end
