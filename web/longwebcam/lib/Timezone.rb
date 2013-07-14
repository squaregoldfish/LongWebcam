# Class for retrieving Time Zone information
# for a given position on the globe. This uses
# the Google Timezone API.
class Timezone

    # Constructor - requires a lon and lat
    def initialize(lon, lat)
        raise ArgumentError, "Invalid longitude" if !lon_ok?(lon)
        raise ArgumentError, "Invalid latitude" if !lat_ok?(lat)

        @lon = convert_lon(lon)
        @lat = lat

        @data_retrieved = false
        @status = nil
        @raw_offset = nil
        @dst_offset = nil
        @time_zone_id = nil
        @time_zone_name = nil

    end

    # Accessors - all read only
    def data_retrieved?
        @data_retrieved
    end

    def lon
        @lon
    end

    def lat
        @lat
    end

    #############################################
    
    def convert_lon(lon)
        converted_lon = lon
        if lon < 0
            converted_lon = 360 - lon.abs
        end

        if lon == 360
            converted_lon = 0
        end

        converted_lon
    end

    def lat_ok?(lat)
        lat >= -90 && lat <= 90
    end

    def lon_ok?(lon)
        lon >= -180 && lon <= 360
    end

end
