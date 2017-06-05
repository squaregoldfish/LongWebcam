module ImagesHelper

	def get_image_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}.png"
	end

	def get_thumbnail_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}_thumb.jpg"
	end

end