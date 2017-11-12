# Module for handling date ranges
module DateRanges
	extend ActiveSupport::Concern

	class DateRange

		# Constructor
		def initialize(start, finish)
			@start = start
			@finish = finish
		end

		# Get the length of the range
		def length
			@finish - @start + 1
		end

		# Make a string representation
		def to_s
			"#{start}->#{finish}"
		end

		def to_json
			"[new Date('#{@start}'), new Date('#{@finish}')]"
		end
	end

	# Class for a set of date ranges
	class DateRangeSet

		# Constructor for an array of dates
		def initialize(dates)
			@ranges = Array.new

			current_range_start = nil
			last_date = nil

			i = 0
			while i < dates.length()
				
				# If we aren't in a range, start a new one
				if current_range_start.nil?
					current_range_start = dates[i]
					last_date = dates[i]
				else
					# If the gap to the previous date is more than one day,
					# we're in a new range. Store the old one and start the new one
					if dates[i] - last_date > 1
						@ranges.push DateRange.new(current_range_start, last_date)
						current_range_start = dates[i]
					end
				end

				last_date = dates[i]
				i = i + 1
			end

			if !current_range_start.nil?
				@ranges.push DateRange.new(current_range_start, last_date)
			end
		end

		def to_json

			json = "["

			i = 0
			while i < @ranges.length()
				json = json + @ranges[i].to_json
				if i < (@ranges.length() - 1)
					json = json + ","
				end

				i = i + 1
			end

			json = json + "]"

			json
		end
	end
end