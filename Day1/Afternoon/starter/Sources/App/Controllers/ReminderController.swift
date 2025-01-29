import Vapor
import Fluent

struct RemindersController: RouteCollection {
    
    func boot(routes: RoutesBuilder) throws {
        let remindersRoutes = routes.grouped("api", "reminders")
        remindersRoutes.post(use: createHandler)
        remindersRoutes.get(use: getAllHandler)
        remindersRoutes.get(":reminderID", use: getHandler)
        remindersRoutes.get(":reminderID", "user", use: getUserHandler)
        remindersRoutes.post(":reminderID", "categories", ":categoryID", use: addCategoriesHandler)
        remindersRoutes.get(":reminderID", "categories", use: getCategoriesHandler)
    }
    
    func createHandler(req: Request) async throws -> Reminder {
        let reminderData = try req.content.decode(CreateReminderData.self)
        let reminder = Reminder(title: reminderData.title, userID: reminderData.userID)
        try await reminder.save(on: req.db)
        return reminder
    }
    
    func getAllHandler(req: Request) async throws -> [Reminder] {
        try await Reminder.query(on: req.db).all()
    }
    
    func getHandler(req: Request) async throws -> Reminder {
        guard let reminder = try await Reminder.find(req.parameters.get("reminderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return reminder
    }
    
    func getUserHandler(req: Request) async throws -> User {
        guard let reminder = try await Reminder.find(req.parameters.get("reminderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await reminder.$user.get(on: req.db)
    }
    
    func addCategoriesHandler(req: Request) async throws -> HTTPStatus {
        guard let reminder = try await Reminder.find(req.parameters.get("reminderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        guard let category = try await Category.find(req.parameters.get("categoryID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await reminder.$categories.attach(category, on: req.db)
        return .ok
    }
    
    func getCategoriesHandler(req: Request) async throws -> [Category] {
        guard let reminder = try await Reminder.find(req.parameters.get("reminderID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await reminder.$categories.get(on: req.db)
    }
}

struct CreateReminderData: Content {
    let title: String
    let userID: User.IDValue
}
