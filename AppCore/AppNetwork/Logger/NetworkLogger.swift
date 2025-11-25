//
//  NetworkLogger.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

protocol NetworkLogger {
    func logRequest(
        _ request: URLRequest,
        body: Data?
    )
    
    func logResponse(
        response: HTTPURLResponse,
        data: Data?,
        duration: TimeInterval
    )
    
    func logError(
        _ error: Error,
        url: String?,
        statusCode: Int?,
        errorBody: Data?
    )
}

final class NetworkLoggerImpl: NetworkLogger {
    
    // MARK: - Request Logging
    
    func logRequest(
        _ request: URLRequest,
        body: Data? = nil
    ) {
        print("\n🚀 ============ REQUEST START ============")
        
        if let method = request.httpMethod, let url = request.url {
            print("📍 \(method) \(url.absoluteString)")
        }
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("\n📋 Headers:")
            headers.forEach { key, value in
                if key.lowercased() == "authorization" {
                    print("  \(key): Bearer ***")
                } else {
                    print("  \(key): \(value)")
                }
            }
        }
        
        if let bodyData = body ?? request.httpBody {
            print("\n📦 Body:")
            if let jsonObject = try? JSONSerialization.jsonObject(with: bodyData),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else if let bodyString = String(data: bodyData, encoding: .utf8) {
                print(bodyString)
            }
        }
        
        print("============ REQUEST END ============\n")
    }
    
    // MARK: - Response Logging
    
    func logResponse(
        response: HTTPURLResponse,
        data: Data?,
        duration: TimeInterval
    ) {
        let emoji = statusEmoji(for: response.statusCode)
        
        print("\n\(emoji) ============ RESPONSE START ============")
        
        print("📍 \(response.statusCode) \(response.url?.absoluteString ?? "")")
        
        let durationString = String(format: "%.3f", duration)
        print("⏱️  Duration: \(durationString)s")
        
        print("\n📋 Headers:")
        response.allHeaderFields.forEach { key, value in
            print("  \(key): \(value)")
        }
        
        if let data = data {
            print("\n📦 Response Body (\(ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .memory))):")
            
            if let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else if let bodyString = String(data: data, encoding: .utf8) {
                print(bodyString)
            }
        }
        
        print("============ RESPONSE END ============\n")
    }
    
    // MARK: - Error Logging
    
    func logError(
        _ error: Error,
        url: String?,
        statusCode: Int?,
        errorBody: Data?
    ) {
        print("\n❌ ============ ERROR START ============")
        if let url = url {
            print("📍 URL: \(url)")
        }
        
        if let statusCode = statusCode {
            let emoji = statusEmoji(for: statusCode)
            print("\(emoji) Status Code: \(statusCode)")
        }
        
        print("⚠️  Error: \(error.localizedDescription)")
        
        if let errorBody = errorBody {
            print("\n📦 Error Response:")
            if let jsonObject = try? JSONSerialization.jsonObject(with: errorBody),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print(prettyString)
            } else if let bodyString = String(data: errorBody, encoding: .utf8) {
                print(bodyString)
            }
        }
        
        print("============ ERROR END ============\n")
    }
    
    // MARK: - Helper
    
    private func statusEmoji(for statusCode: Int) -> String {
        switch statusCode {
        case 200..<300:
            return "✅"
        case 300..<400:
            return "↪️"
        case 400..<500:
            return "⚠️"
        case 500..<600:
            return "❌"
        default:
            return "❓"
        }
    }
}
