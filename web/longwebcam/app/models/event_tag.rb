class EventTag < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :events, :through => :events_tags
end
