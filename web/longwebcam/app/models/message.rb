class Message < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    belongs_to :message_types

    # Direct method for creating a message
    def Message.createMessage(cam_id, type, despatch_to_user, extra_text, extra_data)
        new_message = Message.new
        new_message.camera_id = cam_id
        new_message.timestamp = DateTime.now
        new_message.message_type = type
        new_message.can_despatch = despatch_to_user
        new_message.extra_text = extra_text
        new_message.extra_data = extra_data

        new_message.save
    end

    def to_s
        return "#{self.camera_id}: #{self.extra_text}"
    end

end
