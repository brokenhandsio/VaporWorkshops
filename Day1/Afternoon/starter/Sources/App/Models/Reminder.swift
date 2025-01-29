import Fluent
import Vapor

final class Reminder: Model, Content, @unchecked Sendable {
    static let schema = "reminders"
    
    @ID
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Parent(key: "userID")
    var user: User
    
    @Siblings(through: ReminderCategoryPivot.self,
              from: \.$reminder, to: \.$category)
    var categories: [Category]
    
    init() {}
    init(id: UUID? = nil, title: String, userID: User.IDValue) {
        self.id = id
        self.title = title
        self.$user.id = userID
    }
}
