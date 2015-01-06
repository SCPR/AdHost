module StreamStats
  def self.get
    s = Rails.cache.read("stream_stats")
    s ? Hashie::Mash.new(s) : nil
  end

  def self.cache
    puts "Caching stream stats..."

    sm_config = Rails.application.secrets['stream_machine']
    uri = URI(sm_config['url'])

    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth(sm_config['user'], sm_config['password'])
    response = http.request(request)

    json = JSON.parse(response.body)

    listeners = 0
    json.each do |stream|
      listeners += stream['listeners']
    end

    Rails.cache.write("stream_stats", { ts:Time.zone.now.to_i, listeners:listeners })

    true
  end
end