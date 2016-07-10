class Camera < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
    has_many :messages, :dependent => :destroy
    has_many :images

end
