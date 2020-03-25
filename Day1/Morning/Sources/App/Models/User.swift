import Fluent
import Vapor

final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "username")
    var username: String
    
    @Children(for: \.$user)
    var reminders: [Reminder]
    
    init() {}
    
    init(id: UUID? = nil, name: String, username: String) {
        self.id = id
        self.name = name
        self.username = username
    }
    
}
