class CamerasTags < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
    belongs_to :camera_tags
end
