class CameraDetails < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras

    # A virtual flag to indicate if the lat/lon fields have been changed
    attr_accessor :pos_changed

    # Before saving, look up the time zone for the camera if (a) this is a
    # brand new record (where the details aren't set) or (b) if the position
    # has been changed (indicated by the pos_chanegd flag
    before_save :set_timezone_info, :if=>:timezone_required?

    def timezone_required?
        pos_changed != "" || utc_offset_hour.nil?
    end
