import Fluent
import Foundation

final class ReminderCategoryPivot: Model {
    static let schema = "reminder+category"
    
    @ID(key: .id)
    var id: UUID?
    
    @Parent(key: "reminder_id")
    var reminder: Reminder
    
    @Parent(key: "category_id")
    var category: Category
    
    init() {}
    init(reminderID: Reminder.IDValue, categoryID: Category.IDValue) {
        self.$reminder.id = reminderID
        self.$category.id = categoryID
    }
}
