// 
//  HangoutsModule.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation

public protocol HangoutsModule {
    func makeHangoutsList() -> AnyObject
    
    func makeHangoutsCard(
        model: HangoutsModuleModel.CardInputData,
        onTap: @escaping (() -> Void),
        onButtonTap: @escaping (() -> Void)
    ) -> Any
}
