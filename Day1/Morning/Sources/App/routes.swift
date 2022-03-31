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
    
    app.get("bottles", ":count") { req -> String in
        guard let count = req.parameters.get("count", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return "There were \(count) bottles on the wall"
    }
    
    app.get("hello", ":name") { req -> String in
        guard let name = req.parameters.get("name") else {
            throw Abort(.notFound)
        }
        return "Hello \(name)"
    }
    
    app.get("bottles", "json", ":count") { req -> Bottles in
        guard let count = req.parameters.get("count", as: Int.self) else {
            throw Abort(.badRequest)
        }
        return Bottles(count: count)
    }
    
    app.post("bottles", "json") { req -> String in
        let bottles = try req.content.decode(Bottles.self)
        return "There were \(bottles.count) bottles"
    }
    
    app.post("user-info") { req -> UserMessage in
        let userInfo = try req.content.decode(UserInfo.self)
        let message = "Hello \(userInfo.name), you are \(userInfo.age)"
        return UserMessage(message: message)
    }

    let todoController = TodoController()
    app.get("todos", use: todoController.index)
    app.post("todos", use: todoController.create)
    app.delete("todos", ":todoID", use: todoController.delete)
    
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
