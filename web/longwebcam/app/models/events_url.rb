class EventsUrl < ActiveRecord::Base
    attr_accessible
    belongs_to :event
    belongs_to :event_url
end
