require 'yaml/store'

sentences = ["Habla bien csm.", 'Reencontrate', 'No es palta, es aguacate',
    "Gerry, cómete los bordes", "No coman sobre la alfombra :(",
    "Oe!", "Cuando unas retas de Smash?", "Pikachu flaco es un error",
    "Hmmmm, patas", "Ya pide la pizza carajo", "Tiene tatuajes? No la hago :(",
    "Ahhh, ya sacó a su negro de Roppongi", "Ya, pongan Ruti", "Ayoooos 👋🏻",
    "Casi me matas de la risa don comedia", "Alucina", "Pon una de Luismi",
    "No la hago papi", "RIP", "eeeto, futsu?", "ponedme las pokebolas", "Tamareee",
    "Es del 2006 👀", "Está bien pinche sorda la Marta"]

  
store = YAML::Store.new "sentences.yml"
store.transaction do
  store["sentences"] = sentences
end
