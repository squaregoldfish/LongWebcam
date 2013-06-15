class WeatherCode < ActiveRecord::Base
    attr_accessible
    belongs_to :images
end
