class CamerasController < ApplicationController
	skip_before_action :check_alpha_code

	def search
		render "map"
	end
end