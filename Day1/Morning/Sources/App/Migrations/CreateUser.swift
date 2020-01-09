import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema)
            .field(User.key(for: \.$id), .int, .identifier(auto: true))
            .field(User.key(for: \.$name), .string, .required)
            .field(User.key(for: \.$username), .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(User.schema).delete()
    }
}
