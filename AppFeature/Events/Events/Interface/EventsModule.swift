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

    func makeCreateVC() -> AnyObject

    func makeCreateVC(
        eventId: String,
        prefillData: EventsModuleModel.CreatePrefillData
    ) -> AnyObject
}
