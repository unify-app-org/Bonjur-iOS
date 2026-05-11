//
//  DiscoverRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Clubs
import Events
import Hangouts
import AppUIKit
import Foundation
import AppNetwork
import Communities
import AppPresentationModel

protocol DiscoverRepo {
    
    func getHangout(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData]
}

class DiscoverRepoImpl: DiscoverRepo {
    private let dataSource: DiscoverDataSource
    
    init(
        dataSource: DiscoverDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }
    
    func getHangout(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        let data = try await dataSource.getHangout(query: query.toDictionary())
        let uiModel: [HangoutsModuleModel.CardInputData] = data.map { item in
            let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { item in
                .init(
                    id: item.id ?? 0,
                    type: "",
                    title: item.title ?? "-"
                )
            }
            return .init(
                    id: item.id ?? "-",
                    name: item.name ?? "-",
                    description: item.about ?? "-",
                    memberCount: item.membersCount ?? 0,
                    totalCapacity: item.capacity ?? 0,
                    tags: tags,
                    accessType: item.visibility ?? .private,
                    requestType: .none
                )
        }
        return uiModel
    }
}
