// 
//  ModuleImpl.swift
//  Events
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppPresentationModel
import Events
import SwiftUICore

struct EventsModuleImpl: EventsModule {
    
    func makeEventsCard(
        model: EventsModuleModel.CardInputData,
        onTap: @escaping (() -> Void),
        onButtonTap: @escaping (() -> Void)
    ) -> Any {
        AnyView(
            EventsCardView(
                model: .init(
                    from: model
                ),
                onButtonTap: onButtonTap,
                onTap: onTap
            )
        )
    }
    
    func makeEventsList() -> AnyObject {
        EventsListBuilder(inputData: .init()).build()
    }
    
    func makeEventsDetails(eventId: String) -> AnyObject {
        EventDetailsBuilder(
            inputData: .init(
                eventId: eventId
            )
        ).build()
    }
}
