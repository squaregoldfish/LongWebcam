class Account < ActiveRecord::Base
    attr_accessible :account, :username, :password
end
