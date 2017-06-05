module PrivilegesHelper


    # See if the user can view test cameras
    def can_view_test_cameras
        User.has_privilege(get_privileges, User::PRIVILEGE_VIEW_TEST_CAMERAS)
    end

    private

	# Get the user's privileges from the session.
	# If there are no privileges set, set zero privileges
	# (for guest user)
	def get_privileges
		if session[:privileges].nil?
			session[:privileges] = 0
		end

		session[:privileges]
	end

end