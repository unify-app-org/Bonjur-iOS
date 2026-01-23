// 
//  CommunitiesModule.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation

public protocol CommunitiesModule {
    func makeCommunityCard(
        inputData: CommunitiesModuleModel.CardInputData,
        onTap: @escaping (() -> Void)
    ) -> Any
}
