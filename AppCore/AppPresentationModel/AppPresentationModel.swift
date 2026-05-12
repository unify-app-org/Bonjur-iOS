//
//  AppPresentationModel.swift
//  AppPresentationModel
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation

public enum AppPresentationModel {
    
    // MARK: - Member

    public struct Member: Identifiable, Codable, Hashable {
        public let id: String
        public let profileImage: String?
        
        public init(id: String, profileImage: String?) {
            self.id = id
            self.profileImage = profileImage
        }
    }
    
    // MARK: - Tags

    public struct Tags: Identifiable, Codable, Hashable {
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

    public enum AccessType: String, Codable, Hashable {
        case `public` = "PUBLIC"
        case `private` = "PRIVATE"
    }
    
    // MARK: - Request Type
    
    public enum RequestType: Codable, Hashable {
        case joined
        case rejected
        case pending
        case none
    }
    
    public enum ActivityStatus: String, Codable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
    }
    
    // MARK: - Background  Color Type
    
    public enum BackgroundType: String, Codable, Hashable {
        /// green
        case primary = "GREEN"
        /// blue
        case secondary = "BLUE"
        /// purple
        case teritary = "PURPLE"
        case orange = "ORANGE"
        case red = "RED"
        case pink = "PINK"
    }
    
    // MARK: - Activity Types
    
    public enum ActivityType: Codable, Hashable {
        case community
        case events
        case clubs
        case hangOuts
    }
    
    public enum Gender: String, Codable {
        case male = "MALE"
        case female = "FEMALE"
    }
    
    public struct GenderModel: Identifiable {
        public let id: UUID = UUID()
        public let type: Gender
        public let title: String
        
        public init(type: Gender, title: String) {
            self.type = type
            self.title = title
        }
        
        public static var all: [GenderModel] {
            [
                GenderModel(type: .male, title: "Male"),
                GenderModel(type: .female, title: "Female"),
            ]
        }
        
        public static func title(for type: String) -> String {
            all.first(where: {
                $0.type == .init(rawValue: type) ?? .male
            })?.title ?? ""
        }
    }
}
