//
//  ProfileDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppNetwork

protocol ProfileDataSource {
    func fetchProfile() async throws(APIError) -> ProfileDTOModel.Response
}

final class ProfileDataSourceImpl: NetworkService<ProfileEndPoint>, ProfileDataSource {
    
    func fetchProfile() async throws(APIError) -> ProfileDTOModel.Response {
        try await fetch(endPoint: .getUsers)
    }
}
