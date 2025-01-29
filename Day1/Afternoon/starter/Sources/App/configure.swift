import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateReminder())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateReminderCategoryPivot())
    
    try app.autoMigrate().wait()
    
    // register routes
    try routes(app)
}
