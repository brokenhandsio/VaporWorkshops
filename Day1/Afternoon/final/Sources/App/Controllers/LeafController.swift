import Vapor

struct LeafController: RouteCollection {
    func boot(router: Router) throws {
        router.get(use: indexHandler)
    }
    
    func indexHandler(_ req: Request) throws -> Future<View> {
        let reminders = Reminder.query(on: req).all()
        let context = IndexContext(title: "Homepage", reminders: reminders)
        return try req.view().render("index", context)
    }
}

struct IndexContext: Encodable {
    let title: String
    let reminders: Future<[Reminder]>
}
