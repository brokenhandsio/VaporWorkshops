import FluentSQLite
import Vapor
import Authentication

final class User: Codable {
    var id: Int?
    var name: String
    var username: String
    var password: String
    
    init(name: String, username: String, password: String) {
        self.name = name
        self.username = username
        self.password = password
    }
}

extension User: SQLiteModel {}
extension User: Content {}
extension User: Migration {}
extension User: Parameter {}

extension User {
    var reminders: Children<User, Reminder> {
        return children(\.userID)
    }
}

extension User: BasicAuthenticatable {
    static let usernameKey: UsernameKey = \.username
    static let passwordKey: PasswordKey = \.password
}

struct CreateDefaultUser: SQLiteMigration {
    static func prepare(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        let password = try? BCrypt.hash("password")
        guard let hashedPassword = password else {
            fatalError("Failed to hash password for default user")
        }
        let user = User(name: "Default", username: "default", password: hashedPassword)
        return user.save(on: conn).transform(to: ())
    }
    
    static func revert(on conn: SQLiteConnection) -> EventLoopFuture<Void> {
        return .done(on: conn)
    }
}

extension User: TokenAuthenticatable {
    typealias TokenType = Token
}
