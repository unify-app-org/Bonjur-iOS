//
//  GroupsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppUIKit
import AppNetwork
import Events
import Clubs
import Hangouts

protocol GroupsUseCase {
    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData]
    func fetchClubs() async throws(APIError) -> [ClubsModuleModel.CardInputData]
    func fetchHangouts() async throws(APIError) -> [HangoutsModuleModel.CardInputData]
}

class GroupsUseCaseImpl: GroupsUseCase {
    
    private let dataSource: GroupsDataSource
    
    init(dataSource: GroupsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData] {
        EventsModuleModel.CardInputData.previewMock
    }
    
    func fetchClubs() async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        ClubsModuleModel.CardInputData.previewMock
    }
    
    func fetchHangouts() async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        HangoutsModuleModel.CardInputData.previewMock
    }
}

