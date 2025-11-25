//
//  BaseResponse.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public struct BaseResponse<T: Decodable>: Decodable {
    public let status: String
    public let message: String
    public let data: T
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = try container.decode(String.self, forKey: .status)
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try container.decode(T.self, forKey: .data)
    }
}

public struct EmptyData: Decodable {
    public init() {}
    
    public init(from decoder: Decoder) throws {
    }
}
