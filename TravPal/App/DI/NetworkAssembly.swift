import Foundation
import Swinject
import Alamofire

final class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(Session.self) { _ in Session.default }
            .inObjectScope(.container)

        container.register(KeychainSessionStore.self) { _ in KeychainSessionStore() }
            .inObjectScope(.container)

        container.register(SessionManager.self) { resolver in
            MainActor.assumeIsolated {
                SessionManager(
                    keychain: resolver.resolve(KeychainSessionStore.self)!,
                    session: resolver.resolve(Session.self)!
                )
            }
        }
        .inObjectScope(.container)

        container.register(APIClientProtocol.self) { resolver in
            APIClient(
                session: resolver.resolve(Session.self)!,
                sessionManager: resolver.resolve(SessionManager.self)!
            )
        }
        .inObjectScope(.container)
    }
}
