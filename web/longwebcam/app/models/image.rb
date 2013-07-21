class Image < ActiveRecord::Base
    attr_accessible
    belongs_to :cameras
    has_many :weather_codes, :foreign_key => "code"

    # A utility method for getting the path to an image file
    # identified by Camera ID and date.
    def Image.getImagePath(id, date, suffix)
        # The root path is stored in the database
        root = Account.find_by_account('ImageStore').path
        path = "#{root}/#{id}/#{date}.#{suffix}"

        return path
    end
end
