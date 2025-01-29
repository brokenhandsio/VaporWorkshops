import Fluent
import Vapor

final class Token: Model, Content, @unchecked Sendable {
    static let schema = "tokens"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "token_value")
    var value: String

    @Parent(key: "user_id")
    var user: User

    @Field(key: "expires_at")
    var expiresAt: Date

    init() { }

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
        // Set expirty to 30 days
        self.expiresAt = Date().advanced(by: 60 * 60 * 24 * 30)
    }
}

extension Token: ModelTokenAuthenticatable {
    typealias User = App.User
    static let valueKey = \Token.$value
    static let userKey = \Token.$user

    var isValid: Bool {
        self.expiresAt > Date()
    }
}
