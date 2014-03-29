class EventUrl < ActiveRecord::Base
    attr_accessible
    has_many :events, :through => :events_urls
end
