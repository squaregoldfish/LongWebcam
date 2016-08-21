namespace :user_admin do

	# Create a user with the specified email address
	desc "Creates a user record"
	task :create_user => :environment do

		print "Enter user name: "
		username = STDIN.gets.chomp

		print "Enter email address: "
		email_address = STDIN.gets.chomp

		print "Enter name: "
		name = STDIN.gets.chomp

		puts ""

		begin
			user_password = User.create_user_and_generate_password(username, email_address, name)
		rescue UserExists
			puts "The username is already in use"
		rescue EmailExists
			puts "The email address is already in use"
		else
			puts "User created. Generated password is '#{user_password}'"
		end
	end
end
