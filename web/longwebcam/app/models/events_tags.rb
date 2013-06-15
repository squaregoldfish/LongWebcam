class EventsTags < ActiveRecord::Base
    attr_accessible
    belongs_to :events
    belongs_to :event_tags
end
