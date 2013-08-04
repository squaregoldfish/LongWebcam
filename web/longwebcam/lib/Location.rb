# Various methods for dealing with location data.
#
module Location

    # Converts a longitude from -180 to 180 range into 0 to 360 range
    def self.convert_lon(lon)
        converted_lon = lon
        if lon < 0
            converted_lon = 360 - lon.abs
        end

        if lon == 360
            converted_lon = 0
        end

        converted_lon
    end

    # Checks that a latitude is in the allowed range
    def self.lat_ok?(lat)
        lat >= -90 && lat <= 90
    end

    # Checks that a longitude is in the allowed range.
    # If you're going to use convert_lon, do that before
    # calling this.
    def self.lon_ok?(lon)
        lon >= -180 && lon <= 360
    end

end
