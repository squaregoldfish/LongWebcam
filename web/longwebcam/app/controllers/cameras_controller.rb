class CamerasController < ApplicationController
	include CameraSearchHelper
	skip_before_action :check_alpha_code

	def index
		render "map"
	end

	def doMapSearch
		@searchResults = do_camera_search(params)
		render "map_search_results"
	end
end