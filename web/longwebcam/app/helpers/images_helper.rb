module ImagesHelper

	def get_image_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}.png"
	end

end