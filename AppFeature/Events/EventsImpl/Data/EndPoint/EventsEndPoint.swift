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
}

extension EventsEndPoint: AppEndPoint {

    var path: String {
        switch self {
        case .clubsForEvents:
            "api/cs/v1/clubs/forEvents"
        case .getCategories:
            "api/sd/v1/categories"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .clubsForEvents,
                .getCategories:
                .get
        }
    }
}
