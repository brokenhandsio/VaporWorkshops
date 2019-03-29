import Vapor

public func routes(_ router: Router) throws {
    let usersController = UsersController()
    try router.register(collection: usersController)
    
    let remindersController = RemindersController()
    try router.register(collection: remindersController)
    
    let categoriesController = CategoriesController()
    try router.register(collection: categoriesController)
    
    let leafController = LeafController()
    try router.register(collection: leafController)
}
