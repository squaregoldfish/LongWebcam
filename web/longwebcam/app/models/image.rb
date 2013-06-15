class Image < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
    has_many :weather_codes, :foreign_key => "code"
end
