class Camera < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :users
    
    # General associations
    has_many :messages, :dependent => :destroy
    has_many :camera_details, :dependent => :destroy
    has_many :camera_tags, :through => :cameras_tags
    has_many :images
    has_many :events, :through => :cameras_events

    # Associations for eager loading
    has_one :current_details, -> { order("details_date DESC").limit(1) }, class_name: "CameraDetail"
    has_one :latest_image, -> { where(image_present: 1).order("date DESC").limit(1) }, class_name: "Image"


    # Search scopes
    scope :freetext, -> (text) {where("title LIKE ? OR description LIKE ?", "%#{text}%", "%#{text}%")}

	#####################
    # Constants
	#
	# Codes for camera types
    URL_TYPE = 1
    NET_CONNECTED_TYPE = 2
    STANDALONE_TYPE = 3
end
