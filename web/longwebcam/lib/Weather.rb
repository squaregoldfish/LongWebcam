require 'Location'

# Class for retrieving weather information
# for a given location.
#
class Weather

    # Check the supplied positing and initialise the instance variables
    def initialize(lon, lat)

         # Validate the input parameters
         raise ArgumentError, "Invalid longitude" if !Location.lon_ok?(lon)
         raise ArgumentError, "Invalid latitude" if !Location.lat_ok?(lat)

         # Store the input parameters as instance variables
         @lon = Location.convert_lon(lon)
         @lat = lat

         # Initialise other instance variables
    end
end
