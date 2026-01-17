//
//  DiscoverUseCases.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppUIKit
import AppNetwork

protocol DiscoverUseCase {
    func fetchUserData() async throws(APIError) -> UserModel
    func fetchFilterData() async throws(APIError) -> [FilterView.Model]
    func fetchCommunitiesData() async throws(APIError) -> [CommunityCardView.Model]
    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model]
    func fetchEventsData() async throws(APIError) -> [EventsCardView.Model]
    func fetchHangoutsData() async throws(APIError) -> [HangoutsCardView.Model]
}

class DiscoverUseCaseImpl: DiscoverUseCase {
    
    private let dataSource: DiscoverDataSource
    
    init(dataSource: DiscoverDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func fetchUserData() async throws(APIError) -> UserModel {
        .init(
            id: 1,
            name: "Huseyn Hasanov",
            profileImage: nil,
            greeting: "Welcome to the world of SwiftUI"
        )
    }
    
    func fetchFilterData() async throws(APIError) -> [FilterView.Model] {
        FilterView.Model.mock
    }
    
    func fetchCommunitiesData() async throws(APIError) -> [CommunityCardView.Model] {
        CommunityCardView.Model.mock
    }
    
    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model] {
        ClubCardView.Model.mock
    }
    
    func fetchEventsData() async throws(APIError) -> [EventsCardView.Model] {
        EventsCardView.Model.mock
    }
    
    func fetchHangoutsData() async throws(APIError) -> [HangoutsCardView.Model] {
        HangoutsCardView.Model.mock
    }
}
