import Fluent

struct CreateReminder: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("reminders")
            .id()
            .field("title", .string, .required)
            .field("userID", .uuid, .required,
                   .references("users", "id"))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("reminders").delete()
    }
}
