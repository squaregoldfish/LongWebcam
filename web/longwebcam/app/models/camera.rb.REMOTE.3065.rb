class Camera < ActiveRecord::Base
    attr_accessible 
    belongs_to :users
    has_many :messages, :dependent => :destroy
    has_many :camera_details, :dependent => :destroy
    has_many :camera_tags, :through => :cameras_tags
    has_many :images
    has_many :events, :through => :cameras_events


    # Constants
    URL_TYPE = 1
    NET_CONNECTED_TYPE = 2
    STANDALONE_TYPE = 3
end
