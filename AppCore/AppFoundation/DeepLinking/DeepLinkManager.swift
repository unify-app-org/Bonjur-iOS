//
//  DeepLinkManager.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

/// Read side — dispatch a parsed deep link to whichever module router claims it.
public protocol DeepLinkManagerProtocol {
    func deepLinksIdentifiers() -> [String]
    func canProcess(notification: DeepLinkNotification) -> DeepLinkProcessingResult
    func process(notification: DeepLinkNotification, context: DeepLinkContext)
}

/// Write side — feature modules register their routers during DI setup.
public protocol DeepLinkRegistrar {
    func register(router: [DeepLinkRouter])
    func register(router: DeepLinkRouter)
}

/// App-wide singleton (register both protocols against one instance). Routers
/// are deduplicated by concrete type so repeated module setups are harmless.
public final class DeepLinkManager: DeepLinkManagerProtocol, DeepLinkRegistrar {
    private var routers: [DeepLinkRouter]

    public init() {
        self.routers = []
    }

    public func deepLinksIdentifiers() -> [String] {
        routers.map(\.deepLinkIdentifier)
    }

    public func canProcess(notification: DeepLinkNotification) -> DeepLinkProcessingResult {
        guard let router = routers.first(where: { $0.canProcess(notification: notification) }) else {
            return .none
        }
        return .process(isAuthenticationRequired: router.isAuthenticationRequired)
    }

    public func process(notification: DeepLinkNotification, context: DeepLinkContext) {
        guard let router = routers.first(where: { $0.canProcess(notification: notification) }) else {
            return
        }
        router.process(notification: notification, context: context)
    }

    public func register(router: [any DeepLinkRouter]) {
        router.forEach(register(router:))
    }

    public func register(router: any DeepLinkRouter) {
        if routers.contains(where: { type(of: $0) == type(of: router) }) {
            return
        }
        routers.append(router)
    }
}
