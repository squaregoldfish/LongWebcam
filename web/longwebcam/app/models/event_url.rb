class EventUrl < ActiveRecord::Base
    attr_accessible :title, :url, :accessible, :last_check_date, :last_access_date, :archive_url
end
