// 
//  ModuleImpl.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Hangouts
import SwiftUI

struct HangoutsModuleImpl: HangoutsModule {
    
    func makeHangoutsCard(
        model: HangoutsModuleModel.CardInputData,
        onTap: @escaping () -> Void,
        onButtonTap: @escaping () -> Void
    ) -> Any {
        AnyView(
            HangoutsCardView(
                model: .init(
                    from: model
                ),
                onButtonTap: onButtonTap,
                onTap: onTap
            )
        )
    }
    
    func makeHangoutsList() -> AnyObject {
        HangoutListBuilder(inputData: .init()).build()
    }
    
    func makeCreateVC() -> AnyObject {
        HangoutCreateBuilder(inputData: .init()).build()
    }
    
    func makeCreateVC(
        id: String,
        prefillData: HangoutsModuleModel.CreatePrefillData
    ) -> AnyObject {
        HangoutCreateBuilder(
            inputData: .init(
                id: id,
                prefillData: .init(
                    values: [
                        .visibility: .radio(prefillData.visibility),
                        .hangoutName: .text(prefillData.name),
                        .ownerContact: .text(prefillData.ownerContact),
                        .category: .tags(prefillData.categories.map {
                            .init(id: $0.id, label: $0.title)
                        }),
                        .capacity: .text(prefillData.capacity),
                        .links: .links(prefillData.links.map {
                            .init(type: $0.type, name: $0.name, url: $0.url)
                        }),
                        .location: .text(prefillData.location),
                        .hangoutDate: .date(prefillData.hangoutDate ?? Date()),
                        .rules: .text(prefillData.rules),
                        .about: .text(prefillData.about)
                    ]
                )
            )
        )
        .build()
    }
    
    func makeHangoutDetails(
        hangoutId: String
    ) -> AnyObject {
        HangoutDetailsBuilder(
            inputData: .init(
                hangoutId: hangoutId
            )
        ).build()
    }
}
