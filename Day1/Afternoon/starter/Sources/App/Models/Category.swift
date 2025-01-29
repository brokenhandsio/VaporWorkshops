import Fluent
import Vapor

final class Category: Model, Content, @unchecked Sendable {
    static let schema = "categories"
    
    @ID(custom: "id")
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    @Siblings(through: ReminderCategoryPivot.self,
              from: \.$category, to: \.$reminder)
    var reminders: [Reminder]
    
    init() {}
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
