// 
//  EventsModule.swift
//  Events
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppPresentationModel

public protocol EventsModule {
    
    func makeEventsList() -> AnyObject

    func makeEventsCard(
        model: EventsModuleModel.CardInputData,
        onTap: @escaping (() -> Void),
        onButtonTap: @escaping (() -> Void),
        onClubTap: ((Int) -> Void)?
    ) -> Any
    
    func makeEventsDetails(eventId: String) -> AnyObject

    /// Active events for a club (first page used by the club-detail Events tab).
    func fetchClubEvents(
        clubId: Int,
        page: Int,
        size: Int
    ) async throws -> [EventsModuleModel.CardInputData]

    func makeCreateVC() -> AnyObject

    /// Create entered from a club: the picker opens on `preselectedClubId` when that
    /// club is event-eligible, instead of defaulting to the first one in the list.
    func makeCreateVC(preselectedClubId: Int) -> AnyObject

    func makeCreateVC(
        eventId: String,
        prefillData: EventsModuleModel.CreatePrefillData
    ) -> AnyObject
}
