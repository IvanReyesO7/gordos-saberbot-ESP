def twitch_api_status
    twitch_client = Twitch::Client.new(client_id: 'k4928r3bvo73781oqcxrrm1xuela01')
    p twitch_client.get_users({login: "thecresptv"}).data.first
end
