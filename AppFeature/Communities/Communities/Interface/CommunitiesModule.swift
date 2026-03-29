// 
//  CommunitiesModule.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation

public protocol CommunitiesModule {
    /// Builds a lightweight SwiftUI community card that can be embedded inside other screens.
    ///
    /// Use this when you only need the reusable card UI and want to handle navigation outside
    /// of the module.
    ///
    /// - Parameters:
    ///   - inputData: Visual content and metadata required to render the card.
    ///   - onTap: Called when the card is tapped.
    /// - Returns: A type-erased SwiftUI view containing the community card.
    func makeCommunityCard(
        inputData: CommunitiesModuleModel.CardInputData,
        onTap: @escaping (() -> Void)
    ) -> Any
    
    
    /// Builds the standalone community detail screen.
    ///
    /// Use this when the caller wants the full community detail flow owned by the Communities
    /// feature.
    ///
    /// - Parameter communityId: Identifier of the community to show.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeCommunityDetail(communityId: Int) -> AnyObject
    
    
    /// Builds the faculty selection screen used by the add-members flow.
    ///
    /// This screen lets the user drill into a faculty, select members inside its student list,
    /// and returns the flattened selected member list through the provided callbacks.
    ///
    /// - Parameter input: Screen configuration, faculty rows with embedded student-list data, and completion callbacks.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultyMembersSelection(
        input: CommunitiesMemberModuleModel.FacultySelectionMembersInput
    ) -> AnyObject

    
    /// Builds the faculty selection screen in callback-only mode.
    ///
    /// Use this when the caller only has faculty rows and wants the screen to return the selected
    /// faculties on Next, without requiring preloaded member lists or capacity validation.
    ///
    /// - Parameter input: Screen configuration, faculty rows, and completion callbacks.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultiesSelection(
        input: CommunitiesMemberModuleModel.FacultySelectionFacultiesInput
    ) -> AnyObject

    
    /// Builds the view-only faculty browse screen.
    ///
    /// Use this screen to show rows such as "2002 - Bachelor". When a row is tapped, the screen
    /// pushes the student-list screen for that faculty and forwards tapped members back through the
    /// provided callback.
    ///
    /// - Parameter input: Screen configuration, faculty rows with student-list data, and member tap callback.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultyStudentsBrowse(
        input: CommunitiesMemberModuleModel.FacultyBrowseStudentsInput
    ) -> AnyObject

    
    /// Builds the faculty browse screen in callback-only mode.
    ///
    /// Use this when the caller only has basic faculty rows at first and wants to decide what to
    /// do after a faculty is tapped, such as fetching the student list and pushing the next screen
    /// manually.
    ///
    /// - Parameter input: Screen configuration, faculty rows, and faculty tap callback.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultiesBrowse(
        input: CommunitiesMemberModuleModel.FacultyBrowseFacultiesInput
    ) -> AnyObject

    
    /// Builds the view-only student list screen for a selected faculty or year.
    ///
    /// This screen displays grouped members and forwards member taps back to the caller without
    /// owning any navigation.
    ///
    /// - Parameter input: Screen configuration, grouped members, and tap callback.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultyStudentListView(
        input: CommunitiesMemberModuleModel.FacultyStudentListViewInput
    ) -> AnyObject

    
    /// Builds the selectable student list screen for a selected faculty or year.
    ///
    /// This screen handles member selection, search, and group selection, then returns the
    /// currently selected members when the screen is popped.
    ///
    /// - Parameter input: Screen configuration, grouped members, and completion callbacks.
    /// - Returns: A view controller-like object that can be pushed or presented by the caller.
    func makeFacultyStudentListSelection(
        input: CommunitiesMemberModuleModel.FacultyStudentListSelectInput
    ) -> AnyObject

    
    /// Builds a lightweight members list view for club member sections.
    ///
    /// Use this when you only need grouped owner, president, and member rows backed by the shared
    /// `MemberListView`, while keeping row and options handling in the caller.
    ///
    /// - Parameter input: Member content and callbacks for row taps and options taps.
    /// - Returns: A type-erased SwiftUI view containing the grouped members list.
    func makeMembersListView(
        input: CommunitiesMemberModuleModel.ClubMembersInput
    ) -> Any

}
