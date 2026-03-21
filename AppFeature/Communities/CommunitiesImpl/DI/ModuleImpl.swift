// 
//  ModuleImpl.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Communities
import SwiftUI

struct CommunitiesModuleImpl: CommunitiesModule {
//    func makeMemberSelection(input: Communities.CommunitiesMemberModuleModel.MemberSelectionInput) -> AnyObject {
//        
//    }
//    
    func makeMemberBrowse(
        input: CommunitiesMemberModuleModel.MemberBrowseInput
    ) -> AnyObject {
        MemberBrowseBuilder(
            inputData: .init(
                title: input.title,
                faculties: input.faculties,
                onFacultyTapped: input.onFacultyTapped
            )
        ).build()
    }

    
//    func makeFacultyStudentListView(input: Communities.CommunitiesMemberModuleModel.FacultyStudentListViewInput) -> AnyObject {
//        
//    }
//    
//    func makeFacultyStudentListSelection(input: Communities.CommunitiesMemberModuleModel.FacultyStudentListSelectInput) -> AnyObject {
//        
//    }
//    
//    func makeClubMembers(input: Communities.CommunitiesMemberModuleModel.ClubMembersInput) -> AnyObject {
//        
//    }
//    
//    
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
