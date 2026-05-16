//
//  HangoutsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppNetwork

protocol HangoutsUseCase {
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model]
    func fetchDetailHangout(id: String) async throws(APIError) -> HangoutDetails.UIModel
}

class HangoutsUseCaseImpl: HangoutsUseCase {
    
    private let dataSource: HangoutsDataSource
    
    init(dataSource: HangoutsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model] {
        let data = try await dataSource.fetchHangouts(query: query.toDictionary())
        return data.map { item in
            let tags: [AppUIEntities.Tags] = item.categoryResponses.map { category in
                .init(
                    id: category.id ?? 0,
                    type: "",
                    title: category.title ?? "-"
                )
            }

            return .init(
                id: item.id ?? "-",
                name: item.name ?? "-",
                description: item.about ?? "-",
                memberCount: item.membersCount ?? 0,
                totalCapacity: item.capacity,
                tags: tags,
                accessType: item.visibility ?? .private,
                requestType: .none
            )
        }
    }
    
    func fetchDetailHangout(
        id: String
    ) async throws(APIError) -> HangoutDetails.UIModel {
        HangoutDetails.UIModel.mockData
    }
}
