// 
//  ClubsModule.swift
//  Clubs
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppPresentationModel

public protocol ClubsModule {
    
    func makeClubsViewController() -> AnyObject
    
    func makeCardView(
        inputData: ClubsModuleModel.CardInputData,
        onTap: @escaping (() -> Void)
    ) -> Any
    
    func makeClubsDetailsVC(clubId: Int) -> AnyObject
    
    func makeCreateVC() -> AnyObject
}
