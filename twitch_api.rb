def twitch_api_status
    twitch_client = Twitch::Client.new(
      client_id: 'k4928r3bvo73781oqcxrrm1xuela01',
      client_secret: "mfppcmgp69jzfxtj9jdgfzkqat1erc")
      p twitch_client
end
