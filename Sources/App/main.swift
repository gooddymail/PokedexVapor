import Vapor
import VaporMySQL
import Foundation

let mysql = try VaporMySQL.Provider(host: "localhost", user: "root", password: "", database: "pokedex")

let version = try mysql.driver.raw("SELECT @@version")
print(version)

let drop = Droplet(preparations: [Pokemon.self], initializedProviders: [mysql])

drop.get("pokemon") { request in
  let pokemonsJSON = try Pokemon.all().makeNode().converted(to: JSON.self)
  return pokemonsJSON
}

drop.post("pokemon") { req in
  
  guard let name = req.data["name"]?.string else {
    throw Abort.custom(status: .badRequest, message: "Please include a name.")
  }
  
  if let found = try Pokemon.query().filter("name", name).first() {
    throw Abort.custom(status: .badRequest, message: "You already caught a \(name).")
  }
  
//  let response = try drop.client.get("http://pokeapi.co/api/v2/pokemon/\(name.lowercased())/")
//  let data = response.data
//  guard let id = data["id"]?.int else {
//    throw Abort.custom(status: .badRequest, message: "Invalid Pokemon name.")
//  }
  
  var pokemon = Pokemon(name: name)
  try pokemon.save()
  
  return pokemon
}

drop.get("pokemon", Pokemon.self) { request, pokemon in
//  let response = try drop.client.get("http://pokeapi.co/api/v2/pokemon/\(pokemon.name.lowercased())/")
//  
//  guard let image = response.data["sprites", "front_default"]?.string else {
//    throw Abort.custom(status: .badRequest, message: "Invalid Pokemon name.")
//  }
  
  return try drop.view.make("pokemon.leaf", [
    "name": .string(pokemon.name),
    "date": .string(pokemon.readableDate)
    ])
}

drop.get { req in
    let lang = req.headers["Accept-Language"]?.string ?? "en"
    return try drop.view.make("welcome", [
    	"message": Node.string(drop.localization[lang, "welcome", "title"])
    ])
}

drop.resource("posts", PostController())

drop.run()
