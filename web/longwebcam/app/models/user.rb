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

    # Permissions bits
    PRIVILEGE_VIEW_TEST_IMAGES = 1


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

    # See if a privilieges object has the specified privilege bit set
    def self.has_privilege(privileges, privilege_bit)
        privileges & permission_bit
    end

    # See if the user can view test cameras
    def self.view_test_images(privileges)
        has_privilege(privileges, PRIVILEGE_VIEW_TEST_IMAGES)
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
        authenticated_user
    end

    # Create a new user and generate a password for them
    def User.create_user_and_generate_password(username, email, name)

        # See if the user already exists
        raise UserExists if !User.find_by_username(username).nil?
        raise EmailExists if !User.find_by_email(email).nil?

        # Generate a password
        require 'securerandom'
        generated_password = SecureRandom.urlsafe_base64(8)

        user = User.new
        user.username = username
        user.email = email
        user.firstname = name
        user.new_password = generated_password

        user.save

        generated_password
    end
end


# Exception classes
class UserExists < ArgumentError
end

class EmailExists < ArgumentError
end