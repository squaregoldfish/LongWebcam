class Message < ActiveRecord::Base
    attr_accessible :camera_id, :timestamp, :message_type, :read_by_user, :read_by_admin, :resolved
end
