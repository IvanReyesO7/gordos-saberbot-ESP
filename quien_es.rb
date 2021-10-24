def quien_es(message)
  adjetive = message.match(/.+el más (\w+).*/)[1]
  roll = ["Iván", "David", "David 🇵🇪", "Luis", "Carlos", "Gerry", "Emanuel"]
  return "#{roll.sample} es el más #{adjetive}"
end
