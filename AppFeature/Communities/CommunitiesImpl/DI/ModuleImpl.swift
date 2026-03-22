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
                sectionTitle: input.sectionTitle,
                faculties: input.faculties,
                onFacultyTapped: input.onFacultyTapped
            )
        ).build()
    }

    
    func makeFacultyStudentListView(
        input: CommunitiesMemberModuleModel.FacultyStudentListViewInput
    ) -> AnyObject {
        FacultyStudentListBuilder(
            inputData: .init(
                title: input.title,
                sections: input.sections,
                onMemberTapped: input.onMemberTapped
            )
        ).build()
    }

    func makeFacultyStudentListSelection(
        input: CommunitiesMemberModuleModel.FacultyStudentListSelectInput
    ) -> AnyObject {
        FacultyStudentSelectListBuilder(
            inputData: .init(
                title: input.title,
                sections: input.sections,
                capacityLimit: input.capacityLimit,
                onSelectionConfirmed: input.onSelectionConfirmed,
                onSkip: input.onSkip
            )
        ).build()
    }

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
