// 
//  ModuleImpl.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Hangouts
import SwiftUICore

struct HangoutsModuleImpl: HangoutsModule {
    
    func makeCardView(
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
}
