class AlphaController < ApplicationController
	skip_before_action :check_alpha_code

	def enter_code
		code = params[:code]

		# If no code we'll just go back to the page
		unless code.nil?

			# Check whether the code is valid
			if APP_CONFIG["alpha_code"] == code
				session[:alpha_allowed] = true
				redirect_to "/"
			else
				session[:alpha_allowed] = false
				@check_result = false
			end

		end
	end
end