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
}
