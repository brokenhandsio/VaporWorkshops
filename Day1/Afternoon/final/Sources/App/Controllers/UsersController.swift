import Vapor
import Authentication

struct UsersController: RouteCollection {
    func boot(router: Router) throws {
        let usersRoute = router.grouped("api", "users")
        usersRoute.post(use: createHandler)
        usersRoute.get(use: getAllHandler)
        usersRoute.get(User.parameter, use: getHandler)
        usersRoute.delete(User.parameter, use: deleteHandler)
        usersRoute.put(User.self, at: User.parameter, use: updateHandler)
        usersRoute.get(User.parameter, "reminders", use: getRemindersHandler)
        
        let basicAuthMiddleware = User.basicAuthMiddleware(using: BCryptDigest())
        let loginRouteGroup = usersRoute.grouped(basicAuthMiddleware)
        loginRouteGroup.post("login", use: loginHandler)
    }
    
    func createHandler(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap(to: User.self) { user in
            user.password = try BCrypt.hash(user.password)
            return user.save(on: req)
        }
    }
    
    func getAllHandler(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func getHandler(_ req: Request) throws -> Future<User> {
        return try req.parameters.next(User.self)
    }
    
    func updateHandler(_ req: Request, updatedUser: User) throws -> Future<User> {
        return try req.parameters.next(User.self).flatMap(to: User.self) { user in
            user.name = updatedUser.name
            user.username = updatedUser.username
            user.password = try BCrypt.hash(user.password)
            return user.save(on: req)
        }
    }
    
    func deleteHandler(_ req: Request) throws -> Future<HTTPStatus> {
        let user = try req.parameters.next(User.self)
        return user.delete(on: req).transform(to: .noContent)
    }
    
    func getRemindersHandler(_ req: Request) throws -> Future<[Reminder]> {
        return try req.parameters.next(User.self).flatMap(to: [Reminder].self) { user in
            return try user.reminders.query(on: req).all()
        }
    }
    
    func loginHandler(_ req: Request) throws -> Future<Token> {
        let user = try req.requireAuthenticated(User.self)
        let token = try Token.generate(for: user, on: req)
        return token.save(on: req)
    }
}
