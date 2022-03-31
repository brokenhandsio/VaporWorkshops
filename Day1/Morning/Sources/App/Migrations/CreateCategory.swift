import Fluent

struct CreateCategory: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("categories")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Category.schema).delete()
    }
}

