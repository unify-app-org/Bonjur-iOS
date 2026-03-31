//
//  FacultyStudentListView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct FacultyStudentListView: View {
    @ObservedObject var store: StoreOf<FacultyStudentListFeature>
    
    var body: some View {
        VStack(spacing: 16) {
            ScrollView{
                SearchView(text: searchTextBinding)
                    .padding(.horizontal, 16)
                    .padding(.top,16)
                
                switch store.state.contentState {
                case .list:
                    MemberListView(
                        sections: store.state.filteredSections,
                        onRowTap: { store.send(.memberTapped($0)) },
                        onAccessoryTap: { _ in },
                        onSelectGroupTap: { _ in },
                        showsScrollView: false
                    )
                    
                case .empty:
                    emptyStateView
                    
                case .noSearchResults:
                    emptySearchResultsView
                }
            }
        }
        
        .background(Color.Palette.grayQuaternary.opacity(0.2))
        .navigationTitle(store.state.title)
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    private var searchTextBinding: Binding<String> {
        Binding(
            get: { store.state.searchText },
            set: {
                store.send(.searchChanged($0))
            }
        )
    }
    
    private var emptyStateView: some View {
        Text("No students available")
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }
    
    private var emptySearchResultsView: some View {
        Text("No students found")
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }
    
    
}

// MARK: - Preview

#Preview {
    NavigationStack {
        FacultyStudentListView(store: browsePreviewViewModel.store)
    }
}

private let browsePreviewViewModel: FacultyStudentListViewModel = {
    FacultyStudentListViewModel(
        state: .init(),
        router: PreviewFacultyStudentListRouter(),
        inputData: .init(
            title: "Students - 2002",
            sections: previewBrowseInputSections,
            onMemberTapped: { _ in }
        ),
        dependencies: .init()
    )
}()

private let studentPreviewMembers: [CommunitiesMemberModuleModel.MemberCellModel] = [
    .init(
        id: "1",
        name: "Nihad Asgarli",
        avatarURL: URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg"),
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "2",
        name: "Huseyn Hasanov",
        avatarURL: URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg"),
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "3",
        name: "Durdana Hasanova",
        avatarURL: URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg"),
        subtitle: "Bachelor, Computer engineering, 2017"
    )
]

private let previewBrowseInputSections: [CommunitiesMemberModuleModel.MemberListSection] = [
    .init(
        title: "Computer engineering",
        memberCount: 28,
        members: [
            studentPreviewMembers[0],
            studentPreviewMembers[1],
            studentPreviewMembers[2]
        ]
    ),
    .init(
        title: "Chemistry",
        memberCount: 20,
        members: [
            studentPreviewMembers[1],
            studentPreviewMembers[2]
        ]
    )
]

private final class PreviewFacultyStudentListRouter: FacultyStudentListRouterProtocol {
    @MainActor
    func navigate(to route: FacultyStudentListRoute) {
    }
}
