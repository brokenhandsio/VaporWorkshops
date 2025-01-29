import Vapor
import Fluent

struct UserController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let usersRoutes = routes.grouped("api", "users")
        usersRoutes.post(use: createHandler)
        usersRoutes.get(use: getAllHandler)
        usersRoutes.get(":userID", use: getHandler)
        usersRoutes.delete(":userID", use: deleteHandler)
        usersRoutes.put(":userID", use: updateHandler)
        usersRoutes.get(":userID", "reminders", use: getRemindersHandler)
        usersRoutes.get("reminders", use: getAllUsersWithRemindersEagerHandler)

        let httpBasicAuthRoutes = usersRoutes.grouped(User.authenticator())
        httpBasicAuthRoutes.post("login", use: loginHandler)
    }

    func createHandler(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        user.passwordHash = try Bcrypt.hash(user.passwordHash)
        try await user.save(on: req.db)
        return user
    }

    func getAllHandler(req: Request) async throws -> [User] {
        try await User.query(on: req.db).all()
    }

    func getHandler(req: Request) async throws -> User {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

    func deleteHandler(req: Request) async throws -> HTTPStatus {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return .ok
    }

    func updateHandler(req: Request) async throws -> User {
        let updatedUser = try req.content.decode(User.self)
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        user.name = updatedUser.name
        user.username = updatedUser.username
        user.passwordHash = try Bcrypt.hash(updatedUser.passwordHash)
        try await user.save(on: req.db)
        return user
    }

    func getRemindersHandler(req: Request) async throws -> [Reminder] {
        guard let user = try await User.find(req.parameters.get("userID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await user.$reminders.get(on: req.db)
    }

    func getAllUsersWithRemindersEagerHandler(req: Request) async throws -> [User] {
        try await User.query(on: req.db).with(\.$reminders).all()
    }

    func loginHandler(_ req: Request) async throws -> Token {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        try await token.save(on: req.db)
        return token
    }
}
