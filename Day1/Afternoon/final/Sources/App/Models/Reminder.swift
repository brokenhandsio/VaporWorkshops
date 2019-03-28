import FluentSQLite
import Vapor

final class Reminder: Codable {
    var id: Int?
    var title: String
    var userID: User.ID
    
    init(title: String, userID: User.ID) {
        self.title = title
        self.userID = userID
    }
}

extension Reminder: SQLiteModel {}
extension Reminder: Content {}
extension Reminder: Migration {}
extension Reminder: Parameter {}

extension Reminder {
    var user: Parent<Reminder, User> {
        return parent(\.userID)
    }
    
    var categories: Siblings<Reminder, Category, ReminderCategoryPivot> {
        return siblings()
    }
}
