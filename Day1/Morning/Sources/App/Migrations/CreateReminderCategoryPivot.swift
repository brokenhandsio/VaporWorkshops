import Fluent

struct CreateReminderCategoryPivot: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("reminder+category")
            .id()
            .field("reminderID", .int, .required)
            .field("categoryID", .int, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("reminder+category").delete()
    }
}
