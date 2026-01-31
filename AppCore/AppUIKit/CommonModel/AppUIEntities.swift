//
//  AppUIEntities.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import SwiftUICore

public struct AppUIEntities {
    
    // MARK: - Member Model

    public struct Member: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        public let profileImage: String?
        
        public init(id: Int, profileImage: String?) {
            self.id = id
            self.profileImage = profileImage
        }
    }
    
    // MARK: - Tags

    public struct Tags: Identifiable, Hashable {
        public let uuid: UUID = UUID()
        public let id: Int
        public let type: String
        public let title: String
        
        public init(
            id: Int,
            type: String,
            title: String
        ) {
            self.id = id
            self.type = type
            self.title = title
        }
    }
    
    // MARK: - Access Type

    public enum AccessType {
        case `public`
        case `private`
    }
    
    // MARK: - Request Type

    public enum RequestType {
        case joined
        case rejected
        case pending
        case none
    }
    
    // MARK: - Background  Color Type
    
    public enum BackgroundType {
        /// green
        case primary
        /// blue
        case secondary
        /// purple
        case teritary
        case color(ColorType)
        
        public var bgColor: Color {
            switch self {
            case .primary:
                return .Palette.primary
            case .secondary:
                return .Palette.cardBgSecondry
            case .teritary:
                return .Palette.cardBgTeritary
            case .color(let color):
                switch color {
                case .orange:
                    return .Palette.cardBgOrange
                case .red:
                    return .Palette.cardBgRed
                case .pink:
                    return .Palette.cardBgPink
                case .custom(let color, _, _, _):
                    return color
                }
            }
        }
        
        public var foregroundColor: Color {
            switch self {
            case .teritary, .primary:
                return .Palette.blackHigh
            case .secondary:
                return .Palette.whiteHigh
            case .color(let color):
                switch color {
                case .red:
                    return .Palette.whiteHigh
                case .pink, .orange:
                    return .Palette.blackHigh
                case .custom(_, let foregroundColor, _, _):
                    return foregroundColor
                }
            }
        }
        
        public var arrowTint: Color {
            switch self {
            case .primary:
                return .Palette.whiteHigh
            case .teritary, .secondary:
                return .Palette.blackHigh
            case .color(let color):
                switch color {
                case .pink, .red, .orange:
                    return .Palette.blackHigh
                case .custom(_, _, _, let arrowTint):
                    return arrowTint
                }
            }
        }
        
        public var arrowBgColor: Color {
            switch self {
            case .primary:
                return .Palette.cardBgSecondry
            case .teritary, .secondary:
                return .Palette.primary
            case .color(let color):
                switch color {
                case .pink, .red, .orange:
                    return .Palette.whiteHigh
                case .custom(_, _, let arrowBgColor, _):
                    return arrowBgColor
                }
            }
        }
    }
    
    public enum ColorType {
        case orange
        case red
        case pink
        case custom(
            Color,
            foregroundColor: Color,
            arrowBgColor: Color = .white,
            arrowTint: Color = .Palette.blackHigh
        )
    }
    
    // MARK: - Activity Types
    
    public enum ActivityType {
        case community
        case events
        case clubs
        case hangOuts
    }
    
    public enum UserActivityRole: String, CaseIterable {
        case member = "Members"
        case president = "President"
        case visePresident = "Vise president"
        case eventCreator = "Event creators"
        case notJoined
    }
}
