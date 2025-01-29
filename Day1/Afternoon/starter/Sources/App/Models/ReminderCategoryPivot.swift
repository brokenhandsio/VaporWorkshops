import Fluent
import Foundation

final class ReminderCategoryPivot: Model, @unchecked Sendable {
    static let schema = "reminder+category"
    
    @ID
    var id: UUID?
    
    @Parent(key: "reminderID")
    var reminder: Reminder
    
    @Parent(key: "categoryID")
    var category: Category
    
    init() {}
    
    init(reminderID: Reminder.IDValue, categoryID: Category.IDValue) {
        self.$reminder.id = reminderID
        self.$category.id = categoryID
    }
}
