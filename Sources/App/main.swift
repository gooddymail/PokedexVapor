import Vapor
import VaporMySQL

let drop = Droplet(providers: [VaporMySQL.Provider.self])

drop.post("pokemon") { req in
  guard let name = req.data["name"]?.string else {
    throw Abort.badRequest
  }
  
  return name
}

drop.get { req in
    let lang = req.headers["Accept-Language"]?.string ?? "en"
    return try drop.view.make("welcome", [
    	"message": Node.string(drop.localization[lang, "welcome", "title"])
    ])
}

drop.resource("posts", PostController())

drop.run()
