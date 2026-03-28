//
//  FacultyBrowseView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct FacultyBrowseView: View {
    @ObservedObject var store: StoreOf<FacultyBrowseFeature>
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 16) {
                facultyTextView
                
                if store.state.faculties.isEmpty {
                    emptyStateView
                } else {
                    LazyVStack(spacing: 12) {
                        ForEach(store.state.faculties, id: \.id) { faculty in
                            facultyButton(faculty)
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(Color.Palette.grayQuaternary.opacity(0.3))
        .navigationTitle(store.state.title)
        .onAppear {
            store.send(.onAppear)
        }
    }
    var facultyTextView:some View{
        Text(store.state.sectionTitle)
            .font(Font.Typography.HeadingXl.medium)
            .foregroundStyle(Color.Palette.black)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var emptyStateView: some View {
        Text("No faculties found")
            .font(Font.Typography.HeadingMd.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
    }
    @ViewBuilder
    func facultyButton(_ faculty: CommunitiesMemberModuleModel.FacultyRowModel)->some View{
        FacultyRowView(
            data: .init(
                faculty: faculty,
                accessory: .disclosure
            ),
            onTap: {
                store.send(.facultyTapped(faculty))
            }
        )
        
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FacultyBrowseView(store: previewViewModel.store)
    }
}

#Preview("Empty State") {
    NavigationStack {
        FacultyBrowseView(store: emptyPreviewViewModel.store)
    }
}

private let previewViewModel: FacultyBrowseViewModel = {
    let state = FacultyBrowseViewState()
    state.title = "All member"
    state.sectionTitle = "Faculty"
    state.faculties = [
        .init(id: "1", title: "2002 - Bachelor", sections: previewFacultySections),
        .init(id: "2", title: "2002 - Master", sections: previewFacultySections),
        .init(id: "3", title: "2002 - Doctoral", sections: previewFacultySections),
        .init(id: "4", title: "2003 - Bachelor", sections: previewFacultySections),
        .init(id: "5", title: "2003 - Master", sections: previewFacultySections),
        .init(id: "6", title: "2003 - Doctoral", sections: previewFacultySections)
    ]
    
        return FacultyBrowseViewModel(
            state: state,
            router: PreviewFacultyBrowseRouter(),
            inputData: .init(
                title: state.title,
                sectionTitle: state.sectionTitle,
                faculties: state.faculties,
                mode: .preloadedStudentList(
                    onMemberTapped: { _ in }
                )
            ),
            dependencies: .init()
        )
}()

private let emptyPreviewViewModel: FacultyBrowseViewModel = {
    let state = FacultyBrowseViewState()
    state.title = "All member"
    state.sectionTitle = "Faculty"
    state.faculties = []
    
        return FacultyBrowseViewModel(
            state: state,
            router: PreviewFacultyBrowseRouter(),
            inputData: .init(
                title: state.title,
                sectionTitle: state.sectionTitle,
                faculties: state.faculties,
                mode: .preloadedStudentList(
                    onMemberTapped: { _ in }
                )
            ),
            dependencies: .init()
        )
}()

private let previewFacultyMembers: [CommunitiesMemberModuleModel.MemberCellModel] = [
    .init(
        id: "member-1",
        name: "Nihad Asgarli",
        avatarURL: URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg"),
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "member-2",
        name: "Huseyn Hasanov",
        avatarURL: URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg"),
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "member-3",
        name: "Durdana Hasanova",
        avatarURL: URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg"),
        subtitle: "Bachelor, Chemistry, 2017"
    )
]

private let previewFacultySections: [CommunitiesMemberModuleModel.MemberListSection] = [
    .init(
        title: "Computer engineering",
        memberCount: 28,
        members: [
            previewFacultyMembers[0],
            previewFacultyMembers[1]
        ]
    ),
    .init(
        title: "Chemistry",
        memberCount: 20,
        members: [
            previewFacultyMembers[2]
        ]
    )
]

private final class PreviewFacultyBrowseRouter: FacultyBrowseRouterProtocol {
    @MainActor
    func navigate(to route: FacultyBrowseRoute) {
    }
}
