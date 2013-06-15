class MessageType < ActiveRecord::Base
    attr_accessible
    has_many :messages
end
