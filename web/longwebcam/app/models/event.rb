class Event < ActiveRecord::Base
    attr_accessible
    has_many :cameras, :through => :cameras_events
    has_many :event_urls, :through => :events_urls
    has_many :event_tags, :through => :events_tags
end
