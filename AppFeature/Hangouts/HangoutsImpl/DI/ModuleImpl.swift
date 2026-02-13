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
