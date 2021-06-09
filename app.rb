# app.rb
require 'sinatra'
require 'json'
require 'net/http'
require 'uri'
require 'tempfile'
require 'line/bot'

require_relative 'ibm_watson'
require_relative 'weather_api'
require_relative 'tokyo_events_api'

def client
  @client ||= Line::Bot::Client.new do |config|
    config.channel_secret = ENV['LINE_CHANNEL_SECRET']
    config.channel_token = ENV['LINE_ACCESS_TOKEN']
  end
end

def bot_answer_to(message, user_name)
  # If you want to add Bob to group chat, uncomment the next line
  return '' unless message.downcase.include?("saber") # Only answer to messages with 'bob'

  if message.downcase.include?('hola')
    "Hola #{user_name}, como estas?"
  if message.downcase.include?('presentate')
    "Mi nombre es Saber. Soy una waifu de cartón que vive en la casa del peruano 🇵🇪\n 
    Pienso mudarme cuando termine de comer mi bowl de arroz.\n
    Cuando te dirijas a mí, por favor llámame por mi nombre.\n
    \n
    Puedes ver lo que soy capaz de hacer con el comando `saber comandos`\n
    日本語も話せます！🇯🇵
    \n
    Espero serte de mucha ayuda."
  elsif message.downcase.include?('presidente')
    "Viva Castillo csm ✏️"
  elsif message.downcase.include?('clima en')
    # call weather API in weather_api.rb
    fetch_weather(message)
  elsif message.downcase.include?('reu')
    ['sushi', 'tacos', 'curry', 'pad thai', 'kebab', 'spaghetti', 'burger'].sample
  elsif message.downcase.include?('events')
    # call events API in tokyo_events.rb
    fetch_tokyo_events
  elsif message.match?(/([\p{Hiragana}\p{Katakana}\p{Han}]+)/)
    # respond in japanese!
    bot_jp_answer_to(message, user_name)
  elsif message.end_with?('?')
    # respond if a user asks a question
    "Buena pregunta , #{user_name}!"
  else
    ["Habla bien csm.", 'Reencontrate', 'No es palta, es aguacate',
    "Gerry, cómete los bordes", "No coman sobre la alfombra :(",
    "Oe!", "Cuando unas retas de Smash?", "Pikachu flaco es un error",
    "Hmmmm, patas", "Ya pide la pizza carajo", "Tiene tatuajes? No la hago :(",
    "Ahhh, ya sacó a su negro de Roppongi", "Ya, pongan Ruti", "Ayoooos 👋🏻", "Casi me matas de la risa don comedia",
    "No la hago papi", "RIP", "eeeto, futsu?", "ponedme las pokebolas"].sample
  end
end

def bot_jp_answer_to(message, user_name)
  if message.match?(/(おはよう|こんにちは|こんばんは|ヤッホー|ハロー).*/)
    "こんにちは#{user_name}さん！お元気ですか?"
  elsif message.match?(/.*元気.*(？|\?｜か)/)
    "私は元気です、#{user_name}さん"
  elsif message.match?(/.*(le wagon|ワゴン|バゴン).*/i)
    "#{user_name}さん... もしかして京都のLE WAGONプログラミング学校の話ですかね？ 素敵な画っこと思います！"
  elsif message.end_with?('?','？')
    "いい質問ですね、#{user_name}さん！"
  else
    ['そうですね！', '確かに！', '間違い無いですね！'].sample
  end
end

def send_bot_message(message, client, event)
  # Log prints for debugging
  p 'Bot message sent!'
  p event['replyToken']
  p client

  message = { type: 'text', text: message }
  p message

  client.reply_message(event['replyToken'], message)
  'OK'
end

post '/callback' do
  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end

  events = client.parse_events_from(body)
  events.each do |event|
    p event
    # Focus on the message events (including text, image, emoji, vocal.. messages)
    next if event.class != Line::Bot::Event::Message

    case event.type
    # when receive a text message
    when Line::Bot::Event::MessageType::Text
      user_name = ''
      user_id = event['source']['userId']
      response = client.get_profile(user_id)
      if response.class == Net::HTTPOK
        contact = JSON.parse(response.body)
        p contact
        user_name = contact['displayName']
      else
        # Can't retrieve the contact info
        p "#{response.code} #{response.body}"
      end

      if event.message['text'].downcase == 'hello, world'
        # Sending a message when LINE tries to verify the webhook
        send_bot_message(
          'Everything is working!',
          client,
          event
        )
      else
        # The answer mechanism is here!
        send_bot_message(
          bot_answer_to(event.message['text'], user_name),
          client,
          event
        )
      end
      # when receive an image message
    when Line::Bot::Event::MessageType::Image
      response_image = client.get_message_content(event.message['id'])
      fetch_ibm_watson(response_image) do |image_results|
        # Sending the image results
        send_bot_message(
          "Looking at that picture, the first words that come to me are #{image_results[0..1].join(', ')} and #{image_results[2]}. Pretty good, eh?",
          client,
          event
        )
      end
    end
  end
  'OK'
end
