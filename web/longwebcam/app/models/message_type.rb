class MessageType < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :messages

    # Method to get a message type ID from its code
    def MessageType.getIdFromCode(code)
        result = -1

        mtype = MessageType.find_by_code(code)
        if !mtype.nil?
            result = mtype.id
        end

        result
    end
end
