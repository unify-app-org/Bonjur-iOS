//
//  ClubRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 15.05.26.
//

import Foundation
import AppNetwork
import AppUIKit

protocol ClubRepo {
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func createClub(request: MultipartFormData) async throws(APIError) -> Void
}

class ClubRepoImpl: ClubRepo {
    
    private let dataSource: ClubsDataSource
    
    init(
        dataSource: ClubsDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }
    
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema] {
        try await dataSource.fetchCreate()
    }
    
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let categories: [CategoriesChipsView.Model] = item.subCategories.map { subCategory in
                .init(
                    id: subCategory.id ?? 0,
                    title: subCategory.title ?? "",
                    selected: false
                )
            }
            
            return .init(
                type: item.type ?? "",
                title: item.title ?? "",
                categories: categories
            )
        }
    }
    
    func createClub(
        request: MultipartFormData
    ) async throws(APIError) -> Void {
        let _ = try await dataSource.createClub(request: request)
    }
}
