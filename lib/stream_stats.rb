require 'addressable/uri'

module StreamStats
  def self.get
    s = Rails.cache.read("stream_stats")
    s ? Hashie::Mash.new(s) : nil
  end

  def self.cache
    puts "Caching stream stats..."

    sm_config = Rails.application.secrets['stream_machine']
    uri = Addressable::URI.parse(sm_config['url'])

    http    = Net::HTTP.new(uri.host, uri.port, nil)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    json = JSON.parse(response.body)

    # we skip the first minute SM gives us, since it may still be in flux.
    # just grab avg_listeners out of minute two

    listeners = json[1]['avg_listeners']

    Rails.cache.write("stream_stats", { ts:Time.zone.parse(json[1]['time']).to_i, listeners:listeners })

    true
  end
end