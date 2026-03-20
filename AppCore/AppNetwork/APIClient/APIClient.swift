//
//  APIClient.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation
import AppUtils
import AppLocalization

public protocol APIClientProtocol {
    var activityDelegate: NetworkActivityDelegate? { get set }
    
    func request<T: Decodable>(_ endpoint: AppEndPoint) async throws(APIError) -> T
    func requestRawData(_ endpoint: AppEndPoint) async throws(APIError) -> Data
}

public protocol NetworkActivityDelegate: AnyObject {
    func refreshDidStart()
    func refreshDidFinish()
    
    func refreshFailure()
}

final class APIClient: APIClientProtocol {
    
    // MARK: - Properties
    
    weak var activityDelegate: NetworkActivityDelegate?
    
    private let baseURL: String
    private let session: URLSession
    private let logger: NetworkLogger
    private let tokenManager: TokenManager
    private let localization: AppLocalizationProtocol
    
    // MARK: - Init
    
    public init(
        baseURL: String = AppEnvironment.baseURL,
        session: URLSession = .shared,
        tokenManager: TokenManager = resolve(),
        logger: NetworkLogger = resolve(),
        localization: AppLocalizationProtocol = resolve()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenManager = tokenManager
        self.logger = logger
        self.localization = localization
    }
    
    // MARK: - Request with Auto-Decoding (BaseResponse Wrapper)
    
    public func request<T: Decodable>(_ endpoint: AppEndPoint) async throws(APIError) -> T {
        let data = try await performRequest(endpoint)
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let response = try decoder.decode(T.self, from: data)
            return response
        } catch {
            let error = APIError.decodingError(error)
            logger.logError(
                error,
                url: nil,
                statusCode: nil,
                errorBody: nil
            )
            throw error
        }
    }
    
    // MARK: - Request Raw Data
    
    public func requestRawData(_ endpoint: AppEndPoint) async throws(APIError) -> Data {
        return try await performRequest(endpoint)
    }
    
    // MARK: - Core Request Logic
    
    private func performRequest(
        _ endpoint: AppEndPoint,
        isRetry: Bool = false
    ) async throws(APIError) -> Data {
        guard var urlComponents = URLComponents(string: baseURL + endpoint.path) else {
            throw APIError.invalidURL
        }
        
        if let queryParams = endpoint.queryParameters {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        let defaultHeaders = endpoint.headers ?? [:]
        defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if endpoint.requiresAuth {
            let token = await tokenManager.getAccessToken()
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(localization.currentLanguage, forHTTPHeaderField: "Accept-Language")
        
        var bodyData: Data?
        if let body = endpoint.body {
            do {
                let encoder = JSONEncoder()
                bodyData = try encoder.encode(body)
                
                request.httpBody = bodyData
            } catch {
                let error = APIError.decodingError(error)
                logger.logError(
                    error,
                    url: nil,
                    statusCode: nil,
                    errorBody: nil
                )
                throw error
            }
        }
        
        logger.logRequest(request, body: bodyData)
        
        let startTime = Date()
        
        do {
            let (data, response) = try await session.data(for: request)
            
            let duration = Date().timeIntervalSince(startTime)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }
            
            logger.logResponse(response: httpResponse, data: data, duration: duration)
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
                
            case 401:
                if !isRetry && endpoint.requiresAuth {
                    try await refreshTokenIfNeeded()
                    return try await performRequest(endpoint, isRetry: true)
                } else {
                    if let networkError = try? JSONDecoder().decode(NetworkError.self, from: data) {
                        logger.logError(
                            APIError.error(networkError),
                            url: url.absoluteString,
                            statusCode: httpResponse.statusCode,
                            errorBody: data
                        )
                        throw APIError.error(networkError)
                    }
                    logger.logError(
                        APIError.unauthorized,
                        url: url.absoluteString,
                        statusCode: httpResponse.statusCode,
                        errorBody: data
                    )
                    throw APIError.unauthorized
                }
                
            case 400...499:
                if let networkError = try? JSONDecoder().decode(NetworkError.self, from: data) {
                    logger.logError(
                        APIError.error(networkError),
                        url: url.absoluteString,
                        statusCode: httpResponse.statusCode,
                        errorBody: data
                    )
                    throw APIError.error(networkError)
                }
                logger.logError(
                    APIError.unknown,
                    url: url.absoluteString,
                    statusCode: httpResponse.statusCode,
                    errorBody: data
                )
                throw APIError.unknown
                
            case 500...599:
                if let networkError = try? JSONDecoder().decode(NetworkError.self, from: data) {
                    logger.logError(
                        APIError.error(networkError),
                        url: url.absoluteString,
                        statusCode: httpResponse.statusCode,
                        errorBody: data
                    )
                    throw APIError.error(networkError)
                }
                logger.logError(
                    APIError.unknown,
                    url: url.absoluteString,
                    statusCode: httpResponse.statusCode,
                    errorBody: data
                )
                throw APIError.unknown
                
            default:
                logger.logError(
                    APIError.unknown,
                    url: url.absoluteString,
                    statusCode: httpResponse.statusCode,
                    errorBody: data
                )
                throw APIError.unknown
            }
            
        } catch let error as APIError {
            throw error
        } catch {
            logger.logError(
                error,
                url: url.absoluteString,
                statusCode: nil,
                errorBody: nil
            )
            throw APIError.networkError(error)
        }
    }
    
    // MARK: - Token Refresh
    
    private func refreshTokenIfNeeded() async throws {
        activityDelegate?.refreshDidStart()
        
        defer {
            activityDelegate?.refreshDidFinish()
        }
        
        let refreshToken = await tokenManager.getRefreshToken()
        
        let body = RefreshTokenRequest(
            refreshToken: refreshToken
        )
        let refreshEndpoint = RefreshEndpoint.refresh(body)
        
        do {
            let newTokens: RefreshTokenResponse = try await request(refreshEndpoint)
            
            await tokenManager.saveAccessToken(newTokens.accessToken)
            await tokenManager.saveRefreshToken(newTokens.refreshToken)
        } catch {
            let error = APIError.unauthorized
            logger.logError(
                error,
                url: nil,
                statusCode: nil,
                errorBody: nil
            )
            await tokenManager.clearTokens()
            activityDelegate?.refreshFailure()
            throw error
        }
    }
}
