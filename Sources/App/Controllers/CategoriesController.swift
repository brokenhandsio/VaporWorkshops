import Vapor

struct CategoriesController: RouteCollection {
    func boot(router: Router) throws {
        let categoriesRoute = router.grouped("api", "categories")
        categoriesRoute.post(Category.self, use: createHandler)
        categoriesRoute.get(use: getAllHandler)
        categoriesRoute.get(Category.parameter, use: getHandler)
        categoriesRoute.get(Category.parameter, "reminders", use: getRemindersHandler)
    }
    
    func createHandler(_ req: Request, category: Category) throws -> Future<Category> {
        return category.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Category]> {
        return Category.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Category> {
        return try req.parameters.next(Category.self)
    }
    
    func getRemindersHandler(_ req: Request) throws -> Future<[Reminder]> {
        return try req.parameters.next(Category.self).flatMap(to: [Reminder].self) { category in
            return try category.reminders.query(on: req).all()
        }
    }
}
