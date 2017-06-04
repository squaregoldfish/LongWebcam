class CamerasController < ApplicationController
	skip_before_action :check_alpha_code

	def index
		render "map"
	end

	def doMapSearch
		@searchResults = Camera.all
		render "map_search_results"
	end
end