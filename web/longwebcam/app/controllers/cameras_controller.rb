class CamerasController < ApplicationController
	include CameraSearchHelper
	skip_before_action :check_alpha_code

	def index
		render "search"
	end

	def doSearch
		@searchResults = do_camera_search(params)
		render "search_results"
	end
end