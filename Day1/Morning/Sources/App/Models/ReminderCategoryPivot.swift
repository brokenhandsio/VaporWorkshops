import Fluent

final class ReminderCategoryPivot: Model {
    static let schema = "reminder+category"
    
    @ID(key: "id")
    var id: Int?
    
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
