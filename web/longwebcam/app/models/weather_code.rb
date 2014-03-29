class WeatherCode < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :images
end
