module CameraSearchHelper
	include PrivilegesHelper

	def do_camera_search(search_params)
		
		search_results = nil

		if can_view_test_cameras
			search_results = Camera.where(nil)
		else
			search_results = Camera.where(test_camera: 0)
		end

		search_results = search_results.freetext(params[:freetext]) unless params[:freetext].empty?

		search_results
	end
end