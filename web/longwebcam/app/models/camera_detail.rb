class CameraDetail < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    belongs_to :cameras
end
