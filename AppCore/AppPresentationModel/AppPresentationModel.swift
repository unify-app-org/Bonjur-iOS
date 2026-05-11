//
//  AppPresentationModel.swift
//  AppPresentationModel
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation

public enum AppPresentationModel {
    
    // MARK: - Member

    public struct Member {
        public let id: Int
        public let profileImage: String?
        
        public init(id: Int, profileImage: String?) {
            self.id = id
            self.profileImage = profileImage
        }
    }
    
    // MARK: - Tags

    public struct Tags: Identifiable {
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
    }
    
    public enum ColorType {
        case orange
        case red
        case pink
    }
    
    // MARK: - Activity Types
    
    public enum ActivityType {
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
