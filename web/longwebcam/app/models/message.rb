class Message < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
    belongs_to :message_types
end
