require 'rmagick'

class ImagesController < ApplicationController
	include ImagesHelper
	include PrivilegesHelper
	skip_before_action :check_alpha_code

	def thumbnail
		get_small_image('thumbnail')
	end

	def medium
		get_small_image('medium')
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