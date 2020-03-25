import Fluent

struct CreateReminder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reminders")
            .id()
            .field("title", .string, .required)
            .field("user_id", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reminders").delete()
    }
}
