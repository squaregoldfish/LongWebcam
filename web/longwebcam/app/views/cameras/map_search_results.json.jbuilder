json.array! @searchResults do |camera|
	camera_details = CameraDetails.where(:camera_id => camera.id).order("details_date").last
	unless camera_details.nil?
		json.title camera.title
		json.description camera.description
		json.longitude camera_details.longitude
		json.latitude camera_details.latitude

		image = Image.where(:camera_id => camera.id).where(:image_present => 1).order("date").last
		unless image.nil?
			json.url = thumbnail_image_path(image)
		end
	end
end