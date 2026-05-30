//
//  HangoutsEndPoint 2.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//


import AppNetwork

enum HangoutsEndPoint {
    case getHangouts([String: String])
    case createHangout(HangoutsDTOModel.Request)
    case editHangout(String, HangoutsDTOModel.Request)
    case getCategories
    case hangoutDetail(String)
    case members(String)
}

extension HangoutsEndPoint: AppEndPoint {
    
    var path: String {
        switch self {
        case .getHangouts:
            "api/ds/v1/hangouts"
        case .createHangout:
            "api/hs/v1/hangouts"
        case .editHangout(let id, _):
            "api/hs/v1/hangouts/\(id)"
        case .getCategories:
            "api/sd/v1/categories"
        case .hangoutDetail(let id):
            "api/hs/v1/hangouts/\(id)"
        case .members(let id):
            "api/hs/v1/hangouts/\(id)/members"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHangouts,
                .getCategories,
                .hangoutDetail,
                .members:
                .get
        case .createHangout:
                .post
        case .editHangout:
                .put
        }
    }
    
    var body: Encodable? {
        switch self {
        case .createHangout(let request):
            request
        case .editHangout(_, let request):
            request
        default:
            nil
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .getHangouts(let query):
            query
        default:
            nil
        }
    }
}
