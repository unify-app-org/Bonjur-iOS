// 
//  ModuleImpl.swift
//  Events
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppPresentationModel
import AppUIKit
import Events
import SwiftUI

struct EventsModuleImpl: EventsModule {
    
    func makeEventsCard(
        model: EventsModuleModel.CardInputData,
        onTap: @escaping (() -> Void),
        onButtonTap: @escaping (() -> Void),
        onClubTap: ((Int) -> Void)?
    ) -> Any {
        AnyView(
            EventsCardView(
                model: .init(
                    from: model
                ),
                onButtonTap: onButtonTap,
                onTap: onTap,
                onClubTap: onClubTap
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

    func makeCreateVC() -> AnyObject {
        EventCreateBuilder(
            inputData: .init()
        ).build()
    }

    func makeCreateVC(
        eventId: String,
        prefillData: EventsModuleModel.CreatePrefillData
    ) -> AnyObject {
        EventCreateBuilder(
            inputData: .init(
                eventId: eventId,
                prefillData: .init(
                    selectedClubId: prefillData.clubId,
                    values: [
                        .visibility: .radio(prefillData.visibility),
                        .eventName: .text(prefillData.name),
                        .ownerContact: .text(prefillData.ownerContact),
                        .about: .text(prefillData.about),
                        .category: .tags(prefillData.categories.map {
                            .init(id: $0.id, label: $0.title)
                        }),
                        .location: .text(prefillData.location),
                        .eventDate: .date(prefillData.eventDate),
                        .reminder: .reminders(
                            [AppFieldSchema.ReminderOption(rawValue: prefillData.reminder) ?? .none]
                        ),
                        .capacity: .text(prefillData.capacity),
                        .links: .links(prefillData.links.map {
                            .init(type: $0.type, name: $0.name, url: $0.url)
                        }),
                        .attachment: .attachments(prefillData.attachments.map {
                            .init(name: $0.name, url: $0.url, size: $0.size)
                        }),
                        .rules: .text(prefillData.rules)
                    ]
                )
            )
        ).build()
    }
}
