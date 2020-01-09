import Fluent

struct CreateReminderCategoryPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ReminderCategoryPivot.schema)
            .field(ReminderCategoryPivot.key(for: \.$id), .int, .identifier(auto: true))
            .field(ReminderCategoryPivot.key(for: \.$reminder), .int, .required)
            .field(ReminderCategoryPivot.key(for: \.$category), .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(ReminderCategoryPivot.schema).delete()
    }
}
