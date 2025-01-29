import Vapor

struct LeafController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        routes.get(use: indexHandler)
    }

    func indexHandler(_ req: Request) async throws -> View {
        let reminders = try await Reminder.query(on: req.db).all()
        let context = IndexConxt(title: "Homepage", reminders: reminders)
        return try await req.view.render("index", context)
    }
}

struct IndexConxt: Encodable {
    let title: String
    let reminders: [Reminder]
}
