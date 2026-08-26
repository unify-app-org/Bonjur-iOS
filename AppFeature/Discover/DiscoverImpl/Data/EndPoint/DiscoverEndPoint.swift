//
//  DiscoverEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppNetwork

enum DiscoverEndPoint {
    case getHangouts([String : String])
    case getCommunities([String : String])
    case getClubs([String : String])
    case getEvents([String : String])
    case getCategories
    case getUser
    /// (userId, clubId) — see `ProfileEndPoint.getUserById`; the trailing segment is the
    /// community id.
    case getUserById(String, Int)
    case joinHangout(Encodable)
    case joinEvent(String)
}

extension DiscoverEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getHangouts:
            "api/ds/v1/hangouts"
        case .getCommunities:
            "api/ds/v1/clubs/communities"
        case .getClubs:
            "api/ds/v1/clubs"
        case .getEvents:
            "api/ds/v1/events"
        case .getCategories:
            "api/sd/v1/categories"
        case .getUser:
            "api/us/v1/users/profile"
        case .getUserById(let id, let clubId):
            "api/us/v1/users/\(id)/\(clubId)"
        case .joinHangout:
            "api/hs/v1/hangouts/join"
        case .joinEvent(let id):
            "api/es/v1/events/\(id)/join"
        }
    }
    
    var queryParameters: [String : String]? {
        switch self {
        case .getHangouts(let query),
                .getClubs(let query),
                .getCommunities(let query),
                .getEvents(let query):
                query
        default:
            nil
        }
    }
    
    var body: (any Encodable)? {
        switch self {
        case .joinHangout(let request):
            request
        default:
            nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHangouts,
                .getClubs,
                .getCommunities,
                .getEvents,
                .getCategories,
                .getUser,
                .getUserById:
                .get
        case .joinHangout,
                .joinEvent:
                .post
        }
    }
}
