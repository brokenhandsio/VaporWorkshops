import Fluent

struct CreateReminder: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Reminder.schema)
            .field(Reminder.key(for: \.$id), .int, .identifier(auto: true))
            .field(Reminder.key(for: \.$title), .string, .required)
            .field(Reminder.key(for: \.$user), .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Reminder.schema).delete()
    }
}
