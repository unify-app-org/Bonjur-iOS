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
                    visibility: prefillData.visibility,
                    name: prefillData.name,
                    ownerContact: prefillData.ownerContact,
                    clubName: prefillData.clubName,
                    clubOwnerContact: prefillData.clubOwnerContact,
                    categories: prefillData.categories.map {
                        .init(id: $0.id, label: $0.title)
                    },
                    capacity: prefillData.capacity,
                    links: prefillData.links.map {
                        .init(type: $0.type, name: $0.name, url: $0.url)
                    },
                    rules: prefillData.rules,
                    location: prefillData.location,
                    about: prefillData.about,
                    hangoutDate: prefillData.hangoutDate,
                    endDate: prefillData.endDate
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
