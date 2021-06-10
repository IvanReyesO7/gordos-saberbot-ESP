require 'json'
require 'net/http'
require 'uri'

def get_twitch_user
  # query = message.match(/.+twitch (\w+).*/)[1]
  # query = query.downcase
  query = "thecresptv"
  uri = URI.parse("https://api.twitch.tv/helix/search/channels?query=thecresptv")
  request = Net::HTTP::Get.new(uri)
  request["Client-Id"] = "k4928r3bvo73781oqcxrrm1xuela01"
  request["Authorization"] = "Bearer wn0i367dvejdnc8dcd766qnovrf7ds"

  req_options = {
    use_ssl: uri.scheme == "https",
  }

  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  resp = JSON.parse(response.body)["data"]
    
    p resp
  if !resp.empty?
    user = resp.select{ |user| user["broadcaster_login"] == "#{query}" }
    p user
    if user[0]["is_live"] == true
      return "El usuario #{query} está transmitiendo en vivo!!! 🔴"  
    else
      return "El usuario #{query} no está transmitiendo en este momento." 
    end
  else
    return "#{query}? Quién te conoce papá?."
  end
end

p get_twitch_user