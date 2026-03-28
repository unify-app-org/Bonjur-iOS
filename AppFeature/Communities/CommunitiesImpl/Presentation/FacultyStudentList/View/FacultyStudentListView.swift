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
                
                if store.state.filteredSections.isEmpty{
                    emptySearchStateView
                } else {
                    MemberListView(
                        sections: store.state.filteredSections,
                        onRowTap: { store.send(.memberTapped($0)) },
                        onAccessoryTap: { _ in },
                        onSelectGroupTap: { _ in }
                    )
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

    private var emptySearchStateView: some View {
        Text("No students found")
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }

   
}

#Preview {
    NavigationStack {
        FacultyStudentListView(store: browsePreviewViewModel.store)
    }
}

private var browsePreviewViewModel: PreviewFacultyStudentListViewModel {
    let state = FacultyStudentListViewState()
    state.title = "Students - 2002"
    state.searchText = ""
    state.sections = previewBrowseSections
    state.filteredSections = previewBrowseSections
    return PreviewFacultyStudentListViewModel(state: state)
}

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

private let previewBrowseSections: [MemberListSectionViewData] = [
    .init(
        id: "browse-ce",
        title: "Computer engineering",
        memberCountText: "28 student",
        rows: [
            .disclosure(from: studentPreviewMembers[0]),
            .disclosure(from: studentPreviewMembers[1]),
            .disclosure(from: studentPreviewMembers[2])
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "browse-chem",
        title: "Chemistry",
        memberCountText: "20 student",
        rows: [
            .disclosure(from: studentPreviewMembers[1]),
            .disclosure(from: studentPreviewMembers[2])
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    )
]

private final class PreviewFacultyStudentListViewModel: UIFeatureViewModel<FacultyStudentListFeature> {
    init(state: FacultyStudentListViewState) {
        super.init(initialState: state)
    }

    override func handle(action: FacultyStudentListAction) {
    }
}
