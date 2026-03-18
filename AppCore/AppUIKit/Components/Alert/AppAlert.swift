//
//  AppAlert.swift
//  AppCore
//
//  Created by aplle on 3/18/26.
//


import Foundation

public struct AppAlert {
    public let config: Config
    public let actions: [Action]

    public init(
        config: Config,
        actions: [Action]
    ) {
        self.config = config
        self.actions = actions
    }

    public init(
        config: Config,
        @AppAlertActionBuilder actions: () -> [Action]
    ) {
        self.config = config
        self.actions = actions()
    }
}

public extension AppAlert {
    struct Config {
        public typealias BackgroundTapHandler = (@escaping () -> Void) -> Void

        public let title: String
        public let subtitle: String?
        public let onBackgroundTap: BackgroundTapHandler?

        public init(
            title: String,
            subtitle: String? = nil,
            onBackgroundTap: BackgroundTapHandler? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.onBackgroundTap = onBackgroundTap
        }
    }

    struct Action: Identifiable {
        public typealias Handler = (@escaping () -> Void) -> Void

        public enum Style {
            case primary
            case secondary
        }

        public let id = UUID()
        public let title: String
        public let style: Style
        public let handler: Handler

        public init(
            title: String,
            style: Style,
            handler: @escaping Handler
        ) {
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
}
