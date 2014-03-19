xml.DATA do
  xml.TSEPOCH           DateTime.parse(@response[0]['time']).to_time.to_i
  xml.STREAMINGPLAYERS  @response[0]['value'].to_i
end
