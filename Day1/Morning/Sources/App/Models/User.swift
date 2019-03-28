import FluentSQLite
import Vapor

final class User: Codable {
    var id: Int?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
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
