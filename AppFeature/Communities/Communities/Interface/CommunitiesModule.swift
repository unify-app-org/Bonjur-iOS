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
    
    func makeCommunityDetail(communityId: Int) -> AnyObject
    
//    func makeMemberSelection(
//        input: CommunitiesMemberModuleModel.MemberSelectionInput
//    ) -> AnyObject

    func makeMemberBrowse(
        input: CommunitiesMemberModuleModel.MemberBrowseInput
    ) -> AnyObject

//    func makeFacultyStudentListView(
//        input: CommunitiesMemberModuleModel.FacultyStudentListViewInput
//    ) -> AnyObject
//
//    func makeFacultyStudentListSelection(
//        input: CommunitiesMemberModuleModel.FacultyStudentListSelectInput
//    ) -> AnyObject
//
//    func makeClubMembers(
//        input: CommunitiesMemberModuleModel.ClubMembersInput
//    ) -> AnyObject

}
