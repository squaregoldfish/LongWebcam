class Camera < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    include DateRanges
    belongs_to :users
    
    # General associations
    has_many :messages, :dependent => :destroy
    has_many :camera_details, :dependent => :destroy
    has_many :camera_tags, :through => :cameras_tags
    has_many :images
    has_many :events, :through => :cameras_events

    # Associations for basic camera details
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

    # The date ranges for the camera. Loaded on demand.
    @ranges = nil

    # Determine whether or not this camera has been disabled
    def disabled()
        return disabled == 1 ? true : false
    end

    # Get the image ranges
    def image_ranges
        build_image_ranges
        @ranges.to_json
    end

    # Get the first available image date
    def first_date
        build_image_ranges
        @ranges.first_date
    end

    # Get the latest available image date
    def last_date
        build_image_ranges
        @ranges.last_date
    end

    # Build the image ranges if they don't already exist
    def build_image_ranges
        if @ranges.nil?
            image_dates = Array.new
            images.each do |image|
                image_dates.push image.date
            end

            @ranges = DateRangeSet.new(image_dates)
        end
    end

    # Private methods
    private :build_image_ranges
end
