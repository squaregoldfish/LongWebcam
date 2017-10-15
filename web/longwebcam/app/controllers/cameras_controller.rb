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

	def show
		@camera = Camera.find(params[:id])
		render "camera"
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