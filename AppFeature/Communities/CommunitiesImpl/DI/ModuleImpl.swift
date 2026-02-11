// 
//  ModuleImpl.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Communities
import SwiftUICore

struct CommunitiesModuleImpl: CommunitiesModule {
    
    func makeCommunityCard(
        inputData: CommunitiesModuleModel.CardInputData,
        onTap: @escaping () -> Void
    ) -> Any {
        AnyView(
            CommunityCardView(
                model: .init(from: inputData),
                onTap: onTap
            )
        )
    }
    
    func makeCommunityDetail(
        communityId: Int
    ) -> AnyObject {
        CommunityDetailBuilder(
            inputData: .init(
                communityId: communityId
            )
        ).build()
    }
}
