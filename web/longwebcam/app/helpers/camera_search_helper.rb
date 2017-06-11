module CameraSearchHelper
	include PrivilegesHelper

	def do_camera_search(search_params)
		
		search_results = nil

		if can_view_test_cameras
			search_results = Camera.where(nil)
		else
			search_results = Camera.where(test_camera: false)
		end

		search_results = search_results.freetext(params[:freetext]) unless params[:freetext].empty?

		# Although we need the current_details and latest_image
		# associations, we lazy load them because it's much faster
		search_results
	end
end