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
    
    func createHandler(req: Request) throws -> EventLoopFuture<Reminder> {
        let reminderData = try req.content.decode(CreateReminderData.self)
        let reminder = Reminder(title: reminderData.title, userID: reminderData.userID)
        return reminder.save(on: req.db).map { reminder }
    }
    
    func getAllHandler(req: Request) throws -> EventLoopFuture<[Reminder]> {
        Reminder.query(on: req.db).all()
    }
    
    func getHandler(req: Request) throws -> EventLoopFuture<Reminder> {
        Reminder.find(req.parameters.get("reminderID"), on: req.db).unwrap(or: Abort(.notFound))
    }
    
    func getUserHandler(req: Request) throws -> EventLoopFuture<User> {
        Reminder.find(req.parameters.get("reminderID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { reminder in
            reminder.$user.get(on: req.db)
        }
    }
    
    func addCategoriesHandler(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let reminderFetch = Reminder.find(req.parameters.get("reminderID"), on: req.db).unwrap(or: Abort(.notFound))
        let categoryFetch = Category.find(req.parameters.get("categoryID"), on: req.db).unwrap(or: Abort(.notFound))
        return reminderFetch.and(categoryFetch).flatMap { reminder, category in
            reminder.$categories.attach(category, on: req.db).transform(to: .created)
        }
    }
    
    func getCategoriesHandler(req: Request) throws -> EventLoopFuture<[Category]> {
        Reminder.find(req.parameters.get("reminderID"), on: req.db).unwrap(or: Abort(.notFound)).flatMap { reminder in
            do {
                return try reminder.$categories.query(on: req.db).all()
            } catch {
                return req.eventLoop.future(error: Abort(.internalServerError))
            }
        }
    }
}
