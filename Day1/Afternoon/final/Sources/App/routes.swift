import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { req in
        return "It works!"
    }
    
    // Basic "Hello, world!" example
    router.get("hello") { req in
        return "Hello, world!"
    }
    
    // Example of configuring a controller
    let todoController = TodoController()
    router.get("todos", use: todoController.index)
    router.post("todos", use: todoController.create)
    router.delete("todos", Todo.parameter, use: todoController.delete)
    
    router.get("hello", "workshop") { req in
        return "Hello Vapor Workshop!"
    }
    
    router.get("bottlesft ", Int.parameter) { req -> String in
        let count = try req.parameters.next(Int.self)
        return "There were \(count) bottles on the wall"
    }
    
    router.get("hello", String.parameter) { req -> String in
        let name = try req.parameters.next(String.self)
        return "Hello \(name)"
    }
    
    router.get("bottles", Int.parameter) { req -> Bottles in
        let count = try req.parameters.next(Int.self)
        return Bottles(count: count)
    }
    
    router.post(Bottles.self, at: "bottles") { req, bottles -> String in
        return "There were \(bottles.count) bottles"
    }
    
    router.post(UserInfoData.self, at: "user-info") { req, data -> UserInfo in
        let message = "Hello \(data.name), you are \(data.age)"
        return UserInfo(message: message)
    }
    
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    let remindersController = RemindersController()
    try router.register(collection: remindersController)
    
    let categoriesController = CategoriesController()
    try router.register(collection: categoriesController)
}

struct Bottles: Content {
    let count: Int
}

struct UserInfoData: Content {
    let name: String
    let age: Int
}

struct UserInfo: Content {
    let message: String
}
