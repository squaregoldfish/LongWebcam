require 'rmagick'

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
				thumbnail_location = get_thumbnail_location(image.camera_id, image.date)
				
				if !File.exist?(thumbnail_location)
					full_image_location = get_image_location(image.camera_id, image.date)
				
					if !File.exists?(full_image_location)
						head 404
					else
						image = Magick::Image.read(full_image_location).first
						thumbnail = image.resize_to_fit(300, 300)
						thumbnail.write(thumbnail_location) { self.quality = 85 }
					end
				end

				send_file(thumbnail_location, disposition: "inline")
			end
		rescue ActiveRecord::RecordNotFound
			head 404
		end
	end

	def show
		begin
			image = Image.find(params[:id])
			camera = Camera.find(image.camera_id)

			if camera.test_camera? && !can_view_test_cameras
				head 403
			else
				image_location = get_image_location(image.camera_id, image.date)

				if !File.exists?(image_location)
					head 404
				else
					send_file(image_location, disposition: "inline")
				end
			end
		rescue ActiveRecord::RecordNotFound
			head 404
		end
	end

	def destroy
		head 403
	end

	def update
		head 403
	end

	def create
		head 403
	end

	def new
		head 403
	end

	def edit
		head 403
	end
end