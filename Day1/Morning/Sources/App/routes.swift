import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
    
    app.get("hello", "workshop") { req in
        return "Hello Vapor Workshop!"
    }
    
    app.get("bottles", ":count") { req -> Bottles in
      let count = try req.parameters.require("count", as: Int.self)
      return Bottles(count: count)
    }
    
    app.get("hello", ":name") { req -> String in
        let name = try req.parameters.require("name")
        return "Hello \(name)"
    }
    
    app.post("bottles") { req -> String in
        let bottles = try req.content.decode(Bottles.self)
        return "There were \(bottles.count) bottles"
    }

    app.post("user-info") { req -> UserMessage in
        let userInfo = try req.content.decode(UserInfo.self)
        let message = "Hello \(userInfo.name), you are \(userInfo.age)"
        return UserMessage(message: message)
    }

    try app.register(collection: UserController())
    try app.register(collection: RemindersController())
    try app.register(collection: CategoriesController())
}

struct Bottles: Content {
    let count: Int
}

struct UserInfo: Content {
    let name: String
    let age: Int
}

struct UserMessage: Content {
    let message: String
}
