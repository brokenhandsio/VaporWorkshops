import Fluent
import FluentSQLiteDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.databases.use(DatabaseConfigurationFactory.sqlite(.file("db.sqlite")), as: .sqlite)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateReminder())
    app.migrations.add(CreateCategory())
    app.migrations.add(CreateReminderCategoryPivot())
    app.migrations.add(CreateToken())
    app.migrations.add(CreateDefaultUser())

    try app.autoMigrate().wait()

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
