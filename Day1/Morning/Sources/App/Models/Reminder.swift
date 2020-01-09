import Fluent
import Vapor

final class Reminder: Model, Content {
    static let schema = "reminders"
    
    @ID(key: "id")
    var id: Int?
    
    @Field(key: "title")
    var title: String
    
    @Parent(key: "userID")
    var user: User
    
    @Siblings(through: ReminderCategoryPivot.self, from: \.$reminder, to: \.$category)
    var categories: [Category]
    
    init() {}
    
    init(id: Int? = nil, title: String, userID: User.IDValue) {
        self.id = id
        self.title = title
        self.$user.id = userID
    }
}

struct CreateReminderData: Content {
    let title: String
    let userID: User.IDValue
}
