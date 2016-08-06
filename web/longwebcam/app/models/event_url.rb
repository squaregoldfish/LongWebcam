class EventUrl < ActiveRecord::Base
    has_many :events, :through => :events_urls
end
