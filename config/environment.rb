# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
PFLiveEvents::Application.initialize!

ActiveRecord::ConnectionAdapters::Mysql2Adapter::NATIVE_DATABASE_TYPES[:primary_key] = "CHAR(32) PRIMARY KEY"
