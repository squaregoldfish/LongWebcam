class CameraTag < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :cameras, :through => :cameras_tags
end
