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
        public typealias BackgroundTapHandler = () -> Void

        public let title: String
        public let subtitle: String?
        public let checkbox: Checkbox?
        public let onBackgroundTap: BackgroundTapHandler?

        public init(
            title: String,
            subtitle: String? = nil,
            checkbox: Checkbox? = nil,
            onBackgroundTap: BackgroundTapHandler? = nil
        ) {
            self.title = title
            self.subtitle = subtitle
            self.checkbox = checkbox
            self.onBackgroundTap = onBackgroundTap
        }
    }

    /// Optional opt-out row between the text and the actions, e.g.
    /// "Don't show this again". The alert owns the tick state and reports every
    /// change, so the caller can persist the final value in its action handler.
    struct Checkbox {
        public typealias ChangeHandler = (Bool) -> Void

        public let title: String
        public let isOn: Bool
        public let onChange: ChangeHandler

        public init(
            title: String,
            isOn: Bool = false,
            onChange: @escaping ChangeHandler
        ) {
            self.title = title
            self.isOn = isOn
            self.onChange = onChange
        }
    }

    struct Action: Identifiable {
        public typealias Handler = () -> Void

        public enum Style {
            case primary
            case secondary
            case destructive
        }

        public let id: UUID
        public let title: String
        public let style: Style
        public let handler: Handler

        public init(
            id: UUID = UUID(),
            title: String,
            style: Style,
            handler: @escaping Handler = {}
        ) {
            self.id = id
            self.title = title
            self.style = style
            self.handler = handler
        }
    }
}
