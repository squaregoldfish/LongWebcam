require 'bcrypt'

class User < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :cameras
    has_many :messages, :through => :cameras

    # These are virtual attributes, used for setting/changing the password only
    attr_accessor :new_password, :new_password_confirmation

    # Generate the hashed password if it's changed
    before_save :hash_new_password, :if=>:password_changed?

    # Validate the to passwords match, but only if the password is being changed.
    validates_confirmation_of :new_password, :if=>:password_changed?

    # Determines whether or not a new password has been passed in
    def password_changed?
        !@new_password.blank?
    end

    # Generate a hashed password to store in the database
    def hash_new_password
        # Generate a random salt
        self.password_salt = BCrypt::Engine.generate_salt

        # Hash the salt and password together
        self.password_digest = BCrypt::Engine.hash_secret(@new_password, self.password_salt)
    end

    # As is the 'standard' with rails apps we'll return the user record if the
    # password is correct and nil if it isn't.
    def self.authenticate(username, password)

        authenticated_user = nil
        # Because we use bcrypt we can't do this query in one part, first
        # we need to fetch the potential user
        if user = find_by_username(username)
            # Then compare the provided password against the hashed one in the db.
            if BCrypt::Engine.hash_secret(password, user.password_salt) == user.password_digest
                # If they match we return the user 
                authenticated_user = user
            end
        end
        
        # If we get here it means either there's no user with that email, or the wrong
        # password was provided.  But we don't want to let an attacker know which. 
        return authenticated_user
    end
end
