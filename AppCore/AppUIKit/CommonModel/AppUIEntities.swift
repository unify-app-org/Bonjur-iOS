//
//  AppUIEntities.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import AppLocalization
import SwiftUI
import AppPresentationModel

public enum AppUIEntities {
    
    // MARK: - Member Model

    public typealias Member = AppPresentationModel.Member
    
    // MARK: - Tags

    public typealias Tags = AppPresentationModel.Tags
    
    // MARK: - Access Type

    public typealias AccessType = AppPresentationModel.AccessType
    
    // MARK: - Request Type

    public typealias RequestType = AppPresentationModel.RequestType
    
    // MARK: - Background  Color Type
    
    public typealias BackgroundType = AppPresentationModel.BackgroundType
    
    // MARK: - Activity Types
    
    public typealias ActivityType = AppPresentationModel.ActivityType
    
    // MARK: - User Activity Roles

    public typealias UserActivityRole = AppPresentationModel.UserActivityRole

    // MARK: - Club Status

    public typealias ClubStatus = AppPresentationModel.ClubStatus
}

public extension AppPresentationModel.UserActivityRole {
    /// Localized titles for every role, for handing to modules that must stay free of
    /// localization dependencies (the `Communities` interface module builds member
    /// sections but cannot resolve strings itself). `overrides` wins per role, e.g.
    /// `[.president: "Owner"]` on hangouts/events.
    static func localizedTitles(
        overriding overrides: [AppPresentationModel.UserActivityRole: String] = [:]
    ) -> [AppPresentationModel.UserActivityRole: String] {
        allCases.reduce(into: [:]) { titles, role in
            titles[role] = overrides[role] ?? role.title
        }
    }

    var title: String {
        switch self {
        case .member:
            return "Members".localized
        case .president:
            return "President".localized
        case .visePresident:
            return "Vise president".localized
        case .eventCreator:
            return "Event creators".localized
        case .notJoined:
            return "-"
        case .requested:
            return "-"
        }
    }
}

public extension AppPresentationModel.BackgroundType {
    
    var bgColor: Color {
        switch self {
        case .primary:
            return .Palette.primary
        case .secondary:
            return .Palette.cardBgSecondry
        case .teritary:
            return .Palette.cardBgTeritary
        case .orange:
            return .Palette.cardBgOrange
        case .red:
            return .Palette.cardBgRed
        case .pink:
            return .Palette.cardBgPink
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .teritary, .primary:
            return .Palette.blackHigh
        case .secondary:
            return .Palette.whiteHigh
        case .red:
            return .Palette.whiteHigh
        case .pink, .orange:
            return .Palette.blackHigh
        }
    }
    
    var arrowTint: Color {
        switch self {
        case .primary:
            return .Palette.whiteHigh
        case .teritary, .secondary:
            return .Palette.blackHigh
        case .pink, .red, .orange:
            return .Palette.blackHigh
        }
    }
    
    var arrowBgColor: Color {
        switch self {
        case .primary:
            return .Palette.cardBgSecondry
        case .teritary, .secondary:
            return .Palette.primary
        case .pink, .red, .orange:
            return .Palette.whiteHigh
        }
    }
}
