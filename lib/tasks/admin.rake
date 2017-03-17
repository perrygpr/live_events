namespace :admin do
  desc "Downloads GeoIP.dat from MaxMind"
  task :download_geoip do
    puts "Downloading GeoIP.dat from MaxMind"
    gz = RestClient.get('http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz')
    File.open('tmp/GeoIP.dat', 'wb') do |f|
      Zlib::GzipReader.new(StringIO.new(gz)).each do |chunk|
        f.write(chunk)
      end
    end
  end
end

task :log => :environment do
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end
