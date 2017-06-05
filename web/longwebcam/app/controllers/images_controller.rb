class ImagesController < ApplicationController
	include ImagesHelper
	include PrivilegesHelper
	skip_before_action :check_alpha_code

	def thumbnail
		begin
			image = Image.find(params[:id])
			camera = Camera.find(image.camera_id)

			if camera.test_camera? && !can_view_test_cameras
				head 403
			else
				file_location = get_image_location(image.camera_id, image.date) 
				send_file(file_location, disposition: "inline")
			end
		rescue ActiveRecord::RecordNotFound
			head 404
		end
	end
end