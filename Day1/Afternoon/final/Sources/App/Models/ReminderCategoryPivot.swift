import FluentSQLite
import Foundation

final class ReminderCategoryPivot: SQLiteUUIDPivot {
    var id: UUID?
    var reminderID: Reminder.ID
    var categoryID: Category.ID
    
    typealias Left = Reminder
    typealias Right = Category
    static let leftIDKey: LeftIDKey = \.reminderID
    static let rightIDKey: RightIDKey = \.categoryID
    
    init(_ reminder: Reminder, _ category: Category) throws {
        self.reminderID = try reminder.requireID()
        self.categoryID = try category.requireID()
    }
}

extension ReminderCategoryPivot: ModifiablePivot {}
extension ReminderCategoryPivot: Migration {}
