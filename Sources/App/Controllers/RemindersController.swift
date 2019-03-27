import Vapor

struct RemindersController: RouteCollection {
    func boot(router: Router) throws {
        let remindersRoute = router.grouped("api", "reminders")
        remindersRoute.post(Reminder.self, use: createHandler)
        remindersRoute.get(use: getAllHandler)
        remindersRoute.get(Reminder.parameter, use: getHandler)
        remindersRoute.get(Reminder.parameter, "user", use: getUserHandler)
    }
    
    func createHandler(_ req: Request, reminder: Reminder) throws -> Future<Reminder> {
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
}
