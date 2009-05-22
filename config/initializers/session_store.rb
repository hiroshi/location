# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_location_session',
  :secret      => '538f86cc7d111aa467b60ededa2a621164dbfba1362eb986c83b08063c2e5441d45f1d6786962106fa98369cb690ee0e458efb7918ab90d4728e02f5c5dde026'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
