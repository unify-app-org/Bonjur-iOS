// 
//  ModuleImpl.swift
//  Clubs
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Clubs
import SwiftUI

struct ClubsModuleImpl: ClubsModule {
    func makeClubsViewController() -> AnyObject {
        ClubsBuilder(
            inputData: .init()
        ).build()
    }
    
    func makeCardView(
        inputData: ClubsModuleModel.CardInputData,
        onTap: @escaping (() -> Void)
    ) -> Any {
        AnyView(
            ClubCardView(model: .init(from: inputData), onTap: onTap)
        )
    }
    
    func makeClubsDetailsVC(clubId: Int) -> AnyObject {
        ClubDetailsBuilder(
            inputData: .init(
                clubId: clubId
            )
        ).build()
    }
    
    func makeCreateVC() -> AnyObject {
        ClubCreateBuilder(
            inputData: .init()
        )
        .build()
    }
    
    func makeCreateVC(
        id: Int,
        prefillData: ClubsModuleModel.CreatePrefillData
    ) -> AnyObject {
        ClubCreateBuilder(
            inputData: .init(
                id: id,
                prefillData: .init(
                    logoURL: prefillData.logoURL,
                    coverURL: prefillData.coverURL,
                    values: [
                        .cover: .cover(prefillData.coverType),
                        .visibility: .radio(prefillData.visibility),
                        .clubName: .text(prefillData.name),
                        .ownerContact: .text(prefillData.ownerContact),
                        .category: .tags(prefillData.categories.map {
                            .init(id: $0.id, label: $0.title)
                        }),
                        .capacity: .text(prefillData.capacity),
                        .links: .links(prefillData.links.map {
                            .init(type: $0.type, name: $0.name, url: $0.url)
                        }),
                        .location: .text(prefillData.location),
                        .rules: .text(prefillData.rules),
                        .about: .text(prefillData.about)
                    ]
                )
            )
        )
        .build()
    }
}
