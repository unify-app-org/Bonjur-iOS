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
    case discoverEvents([String: String])
    case clubEvents(Int, [String: String])
    case joinEvent(String)
    case editEvent(String, MultipartFormData)
    case exitEvent(String)
    /// Removes the event itself, not just the caller's membership.
    case deleteEvent(String)
    case sendReminder(String)
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
        case .discoverEvents:
            "api/ds/v1/events"
        case .clubEvents(let clubId, _):
            "api/es/v1/events/\(clubId)/events"
        case .joinEvent(let id):
            "api/es/v1/events/\(id)/join"
        case .editEvent(let id, _):
            "api/es/v1/events/\(id)"
        case .exitEvent(let id):
            "api/es/v1/events/\(id)/exit"
        case .deleteEvent(let id):
            "api/es/v1/events/\(id)"
        case .sendReminder(let id):
            "api/es/v1/events/\(id)/reminder"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .clubsForEvents,
                .getCategories,
                .eventDetail,
                .eventMembers,
                .discoverEvents,
                .clubEvents:
                .get
        case .createEvent,
                .joinEvent,
                .sendReminder:
                .post
        case .editEvent:
                .put
        case .exitEvent,
                .deleteEvent:
                .delete
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .eventMembers(_, let query):
            query
        case .discoverEvents(let query):
            query
        case .clubEvents(_, let query):
            query
        default:
            nil
        }
    }

    var multipartFormData: MultipartFormData? {
        switch self {
        case .createEvent(let multiPart):
            multiPart
        case .editEvent(_, let multiPart):
            multiPart
        default:
            nil
        }
    }

    var contentType: ContentType {
        switch self {
        case .createEvent,
                .editEvent:
                .formData
        default:
                .json
        }
    }
}
