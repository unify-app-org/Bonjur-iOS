// 
//  HangoutsModule.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation

public protocol HangoutsModule {
    func makeHangoutsList() -> AnyObject
    
    func makeCreateVC() -> AnyObject
    
    func makeCreateVC(
        id: String,
        prefillData: HangoutsModuleModel.CreatePrefillData
    ) -> AnyObject
    
    func makeHangoutsCard(
        model: HangoutsModuleModel.CardInputData,
        onTap: @escaping (() -> Void),
        onButtonTap: @escaping (() -> Void)
    ) -> Any
    
    func makeHangoutDetails(hangoutId: String) -> AnyObject
}
