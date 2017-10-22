module ImagesHelper

	def get_image_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}.png"
	end

	def get_thumbnail_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}_thumb.jpg"
	end

	def get_medium_location(camera_id, date)
		return "#{APP_CONFIG["image_store"]}/#{camera_id}/#{date}_med.jpg"
	end

	# Get a small version of an image
	def get_small_image(identity)
		begin
			image = Image.find(params[:id])
			camera = Camera.find(image.camera_id)

			if camera.test_camera? && !can_view_test_cameras
				head 403
			else
				case identity
				when 'thumbnail'
					location = get_thumbnail_location(image.camera_id, image.date)
				when 'medium'
					location = get_medium_location(image.camera_id, image.date)
				end

				if !File.exist?(location)
					full_image_location = get_image_location(image.camera_id, image.date)
				
					if !File.exists?(full_image_location)
						head 404
					else
						image = Magick::Image.read(full_image_location).first
						
						case identity
						when 'thumbnail'
							size = 300
						when 'medium'
							size = 600
						end

						resized = image.resize_to_fit(size, size)
						resized.write(location) { self.quality = 85 }
					end
				end

				send_file(location, disposition: "inline")
			end
		rescue ActiveRecord::RecordNotFound
			head 404
		end
	end
end