class SearchController < ApplicationController
	skip_before_action :check_alpha_code
end