class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :county
      t.string :country
      t.string :postcode
      t.integer :privileges

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
