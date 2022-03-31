import Fluent

struct CreateReminderCategoryPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("reminder+category")
            .id()
            .field("reminder_id", .uuid, .required)
            .field("category_id", .uuid, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ReminderCategoryPivot.schema).delete()
    }
}
