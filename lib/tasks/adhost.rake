require 'net/http'

namespace :adhost do
  task :stream_stats => [:environment] do
    puts "Caching stream stats..."

    sm_config = Rails.application.config.secrets['stream_machine']
    uri = URI("http://205.144.162.150:8022/api/streams")

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(sm_config['user'], sm_config['password'])
    response = http.request(request)

    json = JSON.parse(response.body)
    puts json

    Rails.cache.write("adhost:stream_stats:last_cache", Time.now.to_i)
    Rails.cache.write("adhost:stream_stats", json)

    puts "Finished."
  end
end
