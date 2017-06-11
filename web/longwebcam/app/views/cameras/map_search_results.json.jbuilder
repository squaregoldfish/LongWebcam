json.array! @searchResults do |camera|
	unless camera.current_details.nil?
		json.id camera.id
		json.title camera.title
		json.description camera.description
		json.longitude camera.current_details.longitude
		json.latitude camera.current_details.latitude

		unless camera.latest_image.nil?
			json.url = thumbnail_image_path(camera.latest_image)
		end
	end
end