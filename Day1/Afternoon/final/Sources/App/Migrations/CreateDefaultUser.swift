import Vapor
import Fluent

struct CreateDefaultUser: AsyncMigration {
    func prepare(on database: Database) async throws {
        let password = try Bcrypt.hash("password")
        let user = User(name: "default", username: "default", passwordHash: password)
        try await user.create(on: database)
    }

    func revert(on database: any Database) async throws {
        try await User.query(on: database).filter(\.$username == "default").delete()
    }
}
