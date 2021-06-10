def twitch_api_status
    twitch_client = Twitch::Client.new(
        client_id: 'k4928r3bvo73781oqcxrrm1xuela01',
        client_secret: 'mfppcmgp69jzfxtj9jdgfzkqat1erc',
      
        ## this is default
        # token_type: :application,
      
        ## this can be required by some Twitch end-points
        # scopes: scopes,
      
        ## if you already have one
        # access_token: access_token
      )
      p twitch_client
end
