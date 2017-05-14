module Authentication
	extend ActiveSupport::Concern

	# Check the session to see if the user has
	# passed the alpha code check
	def check_alpha_code
		unless session[:alpha_allowed]
			redirect_to "/alpha/enter_code"
		end
	end
end