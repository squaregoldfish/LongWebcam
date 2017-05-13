class AlphaController < ApplicationController
	def enter_code
		code = params[:code]


		# If no code we'll just go back to the page
		unless code.nil?

			# Check whether the code is valid
			if code_valid(code)
				session[:alpha_allowed] = true
				redirect_to "/"
			else
				session[:alpha_allowed] = false
				@check_result = false
			end

		end
	end

	def code_valid(code)
		return APP_CONFIG["alpha_code"] == code
	end
end