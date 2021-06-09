def quien_es(message)
  adjetive = message.match(/.+el mas (\w+).*/)[1]
  roll = ["Ivan", "David", "David", "Luis", "Carlos", "Gerry"]
  return "#{roll.sample} es el más #{adjetive}"
end