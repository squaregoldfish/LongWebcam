json.array! @searchResults do |camera|
	details = camera.camera_details.order("details_date").last
	unless details.nil?
		json.id camera.id
		json.title camera.title
		json.description camera.description
		json.longitude details.longitude
		json.latitude details.latitude

		image = camera.images.where(:image_present => 1).order("date").last
		unless image.nil?
			json.url = thumbnail_image_path(image)
		end
	end
end