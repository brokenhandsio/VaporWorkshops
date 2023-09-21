import Fluent

struct CreateReminderCategoryPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("reminder+category")
            .id()
            .field("reminderID", .uuid, .required, .references("reminders", "id", onDelete: .cascade))
            .field("categoryID", .int, .required, .references("categories", "id", onDelete: .cascade))
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("reminder+category").delete()
    }
}
