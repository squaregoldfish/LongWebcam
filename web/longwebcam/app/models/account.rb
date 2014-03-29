class Account < ActiveRecord::Base
    include ActiveModel::ForbiddenAttributesProtection
end
