class EventTag < ActiveRecord::Base
    attr_accessible
    has_many :events, :through => :events_tags
end
