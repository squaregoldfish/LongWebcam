# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_lwc_beta_session',
  :secret      => '6ff81f0c24912995c8f3a8e1db01afcb6c5c341a5578851073a6df68776eb25e47238b16e90164442a24b576febb12c35d46eb554bea451df6f4e0c28222c5c3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
