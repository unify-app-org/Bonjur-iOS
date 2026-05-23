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

    public enum AccessType: String, Codable, Hashable, CaseIterableWithDefault {
        public static var defaultValue: AppPresentationModel.AccessType = .private
        
        case `public` = "PUBLIC"
        case `private` = "PRIVATE"
    }
    
    // MARK: - Request Type
    
    public enum RequestType: String, Codable, Hashable, CaseIterableWithDefault {
        public static var defaultValue: AppPresentationModel.RequestType = .none
        
        case joined = "ACCEPTED"
        case rejected = "REJECTED"
        case pending = "PENDING"
        case none
    }
    
    public enum ActivityStatus: String, Codable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
    }
    
    // MARK: - Background  Color Type
    
    public enum BackgroundType: String, Codable, Hashable, CaseIterableWithDefault {
        public static var defaultValue: AppPresentationModel.BackgroundType = .primary
        
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
    
    // MARK: - User Activity Role
    
    public enum UserActivityRole: String, Codable, CaseIterable, CaseIterableWithDefault {
        public static var defaultValue: AppPresentationModel.UserActivityRole = .member
        
        case member = "MEMBER"
        case president = "PRESIDENT"
        case visePresident = "VICE_PRESIDENT"
        case eventCreator = "EVENT_CREATOR"
        case notJoined
    }
    
    // MARK: - Activity Types
    
    public enum ActivityType: Codable, Hashable {
        case community
        case events
        case clubs
        case hangOuts
    }
    
    public enum Gender: String, Codable, CaseIterableWithDefault {
        public static var defaultValue: AppPresentationModel.Gender = .male
        
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
    
    
    // MARK: - UserResponse
    
    public struct UserResponse: Decodable {
        public let fullName, mail, phone, faculty, communityName: String?
        public let specialization, username, about, degree, fileUrl, greeting: String?
        public let background: AppPresentationModel.BackgroundType?
        public let entryYear, year: Int?
        public let gender: AppPresentationModel.Gender?
        public let birthDate: String?
        public let categories: [Category]?
        public let languages: [Language]?
        
        public init(
            fullName: String?,
            mail: String?,
            phone: String?,
            faculty: String?,
            specialization: String?,
            username: String?,
            about: String?,
            degree: String?,
            fileUrl: String?,
            background: AppPresentationModel.BackgroundType?,
            entryYear: Int?,
            year: Int?,
            gender: AppPresentationModel.Gender?,
            birthDate: String?,
            communityName: String?,
            greeting: String?,
            categories: [Category]?,
            languages: [Language]?
        ) {
            self.fullName = fullName
            self.mail = mail
            self.phone = phone
            self.faculty = faculty
            self.specialization = specialization
            self.username = username
            self.about = about
            self.degree = degree
            self.fileUrl = fileUrl
            self.background = background
            self.entryYear = entryYear
            self.year = year
            self.gender = gender
            self.birthDate = birthDate
            self.categories = categories
            self.languages = languages
            self.greeting = greeting
            self.communityName = communityName
        }
        
        public struct Category: Decodable {
            public let id: Int?
            public let title: String?
            
            public init(id: Int?, title: String?) {
                self.id = id
                self.title = title
            }
        }
        
        public struct Language: Decodable {
            public let id: Int?
            public let name: String?
            
            public init(id: Int?, name: String?) {
                self.id = id
                self.name = name
            }
        }
        
        enum CodingKeys: String, CodingKey {
            case fullName, communityName
            case mail
            case phone
            case faculty
            case specialization
            case username
            case about
            case degree
            case fileUrl
            case background = "backgroundColour"
            case entryYear
            case year
            case gender
            case birthDate
            case categories
            case languages
            case greeting
        }
    }
}

public protocol CaseIterableWithDefault:
    Decodable & CaseIterable & RawRepresentable where RawValue: Decodable, AllCases: BidirectionalCollection {
    static var defaultValue: AllCases.Element { get }
}

public extension CaseIterableWithDefault {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? Self.defaultValue
    }
}
