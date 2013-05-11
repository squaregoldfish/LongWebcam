class User < ActiveRecord::Base
    attr_accessible :username, :password_digest, :email, :firstname, :lastname, :address1, :address2, :address3, :city, :county, :country, :postcode, :privileges
end
