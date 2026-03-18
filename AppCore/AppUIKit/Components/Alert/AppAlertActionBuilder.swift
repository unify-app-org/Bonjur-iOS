//
//  AppAlertActionBuilder.swift
//  AppUIKit
//
//  Created by aplle on 3/18/26.
//

import Foundation

@resultBuilder
 enum AppAlertActionBuilder {
    public static func buildBlock(_ components: AppAlert.Action...) -> [AppAlert.Action] {
        components
    }

    public static func buildOptional(_ component: [AppAlert.Action]?) -> [AppAlert.Action] {
        component ?? []
    }

    public static func buildEither(first component: [AppAlert.Action]) -> [AppAlert.Action] {
        component
    }

    public static func buildEither(second component: [AppAlert.Action]) -> [AppAlert.Action] {
        component
    }

    public static func buildArray(_ components: [[AppAlert.Action]]) -> [AppAlert.Action] {
        components.flatMap { $0 }
    }
}
