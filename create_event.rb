def send_bot_event(message, client, event)
  p 'Bot message sent!'
  p event['replyToken']
  p client

  message = { type: 'datetimepicker', label: "Test", data: "storeId=12345", mode: "datetime" }
  client.reply_message(event['replyToken'], message)
  'OK'
end