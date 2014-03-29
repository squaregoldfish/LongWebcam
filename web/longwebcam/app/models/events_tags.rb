class EventsTags < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :events
    belongs_to :event_tags
end
