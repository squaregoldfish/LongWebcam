class EventsUrl < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :event
    belongs_to :event_url
end
