import Vapor

struct RemindersController: RouteCollection {
    func boot(router: Router) throws {
        let remindersRoute = router.grouped("api", "reminders")
        remindersRoute.get(use: getAllHandler)
        remindersRoute.get(Reminder.parameter, use: getHandler)
        remindersRoute.get(Reminder.parameter, "user", use: getUserHandler)
        remindersRoute.get(Reminder.parameter, "categories", use: getCategoriesHandler)
        
        let tokenAuthMiddleware = User.tokenAuthMiddleware()
        let protectedRoutes = remindersRoute.grouped(tokenAuthMiddleware)
        protectedRoutes.post(CreateReminderData.self, use: createHandler)
        protectedRoutes.post(Reminder.parameter, "categories", Category.parameter, use: addCategoriesHandler)
    }
    
    func createHandler(_ req: Request, data: CreateReminderData) throws -> Future<Reminder> {
        let user = try req.requireAuthenticated(User.self)
        let reminder = try Reminder(title: data.title, userID: user.requireID())
        return reminder.save(on: req)
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[Reminder]> {
        return Reminder.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<Reminder> {
        return try req.parameters.next(Reminder.self)
    }
    
    func getUserHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(Reminder.self).flatMap(to: User.self) { reminder in
            return reminder.user.get(on: req)
        }
    }
    
    func addCategoriesHandler(_ req: Request) throws -> Future<HTTPStatus> {
        return try flatMap(to: HTTPStatus.self, req.parameters.next(Reminder.self), req.parameters.next(Category.self)) { reminder, category in
            return reminder.categories.attach(category, on: req).transform(to: .created)
        }
    }
    
    func getCategoriesHandler(_ req: Request) throws -> Future<[Category]> {
        return try req.parameters.next(Reminder.self).flatMap(to: [Category].self) { reminder in
            return try reminder.categories.query(on: req).all()
        }
    }
}

struct CreateReminderData: Content {
    let title: String
}
