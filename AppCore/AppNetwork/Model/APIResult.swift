//
//  APIResult.swift
//  AppNetwork
//
//  Created by Huseyn Hasanov on 23.05.26.
//

public typealias APIResult<T> = Result<T, APIError>

public func apiResult<T>(
    _ operation: () async throws -> T
) async -> APIResult<T> {
    do {
        return .success(try await operation())
    } catch let error as APIError {
        return .failure(error)
    } catch {
        return .failure(.networkError(error))
    }
}
