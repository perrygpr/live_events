require 'dragonfly/rails/images'
require 'excon'

app = Dragonfly[:images]

app.datastore = Dragonfly::DataStorage::S3DataStore.new

app.datastore.configure do |c|
  c.bucket_name = ENV['bucket_name']
  c.access_key_id = ENV['access_key']
  c.secret_access_key = ENV['secret_key']
  c.region = ENV['region']
  c.url_host = ENV['cdn_url'] if ENV['cdn_url']
end

# Required for jruby on rails
Excon.defaults[:nonblock] = false
