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
    
    func makeFacultySelection(
        input: CommunitiesMemberModuleModel.FacultySelectionMembersInput
    ) -> AnyObject {
        FacultySelectionBuilder(
            inputData: .init(
                title: input.title,
                sectionTitle: input.sectionTitle,
                mode: .preloadedMembers(
                    faculties: input.faculties,
                    capacityLimit: input.capacityLimit,
                    onNext: input.onNext
                ),
                onSkip: input.onSkip
            )
        ).build()
    }

    func makeFacultySelection(
        input: CommunitiesMemberModuleModel.FacultySelectionFacultiesInput
    ) -> AnyObject {
        FacultySelectionBuilder(
            inputData: .init(
                title: input.title,
                sectionTitle: input.sectionTitle,
                mode: .callback(
                    faculties: input.faculties,
                    onNext: input.onNext
                ),
                onSkip: input.onSkip
            )
        ).build()
    }

    func makeFacultyBrowse(
        input: CommunitiesMemberModuleModel.FacultyBrowseStudentsInput
    ) -> AnyObject {
        FacultyBrowseBuilder(
            inputData: .init(
                title: input.title,
                sectionTitle: input.sectionTitle,
                faculties: input.faculties,
                mode: .preloadedStudentList(
                    onMemberTapped: input.onMemberTapped
                )
            )
        ).build()
    }

    func makeFacultyBrowse(
        input: CommunitiesMemberModuleModel.FacultyBrowseFacultiesInput
    ) -> AnyObject {
        FacultyBrowseBuilder(
            inputData: .init(
                title: input.title,
                sectionTitle: input.sectionTitle,
                faculties: input.faculties,
                mode: .callback(
                    onFacultyTapped: input.onFacultyTapped
                )
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
                initiallySelectedMembers: input.initiallySelectedMembers,
                onSelectionConfirmed: input.onSelectionConfirmed
            )
        ).build()
    }

    func makeClubMembers(
        input: CommunitiesMemberModuleModel.ClubMembersInput
    ) -> Any {
        AnyView(
            MemberListView(
                sections: .clubMembers(from: input),
                onRowTap: { row in
                    input.onMemberTapped(row.member)
                },
                onAccessoryTap: { row in
                    input.onOptionsTapped(row.member)
                },
                onSelectGroupTap: { _ in }
            )
        )
    }
    
    
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
