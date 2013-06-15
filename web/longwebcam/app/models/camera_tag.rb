class CameraTag < ActiveRecord::Base
    attr_accessible 
    has_many :cameras, :through => :cameras_tags
end
