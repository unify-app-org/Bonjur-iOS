//
//  EventsEndPoint.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppNetwork

enum EventsEndPoint {
    case clubsForEvents
    case getCategories
    case createEvent(MultipartFormData)
    case eventDetail(String)
    case eventMembers(String, [String: String])
}

extension EventsEndPoint: AppEndPoint {

    var path: String {
        switch self {
        case .clubsForEvents:
            "api/cs/v1/clubs/forEvents"
        case .getCategories:
            "api/sd/v1/categories"
        case .createEvent:
            "api/es/v1/events"
        case .eventDetail(let id):
            "api/es/v1/events/\(id)"
        case .eventMembers(let id, _):
            "api/es/v1/events/\(id)/members"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .clubsForEvents,
                .getCategories,
                .eventDetail,
                .eventMembers:
                .get
        case .createEvent:
                .post
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .eventMembers(_, let query):
            query
        default:
            nil
        }
    }

    var multipartFormData: MultipartFormData? {
        switch self {
        case .createEvent(let multiPart):
            multiPart
        default:
            nil
        }
    }

    var contentType: ContentType {
        switch self {
        case .createEvent:
                .formData
        default:
                .json
        }
    }
}
