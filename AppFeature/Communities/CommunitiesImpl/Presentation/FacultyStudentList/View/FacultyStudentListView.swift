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
            headerView
            facultyChooserView
            SearchView(text: searchTextBinding)

            MemberListView(
                sections: store.state.sections,
                onRowTap: { store.send(.memberTapped($0)) },
                onAccessoryTap: { store.send(.accessoryTapped($0)) },
                onSelectGroupTap: { store.send(.groupTapped($0)) }
            )

            if store.state.isSelectionMode {
                actionButtonsView
            }
        }
        .padding(.top, 16)
        .background(Color.Palette.grayQuaternary.opacity(0.2))
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var searchTextBinding: Binding<String> {
        Binding(
            get: { store.state.searchText },
            set: { store.send(.searchChanged($0)) }
        )
    }

    private var headerView: some View {
        Text(store.state.title)
            .font(Font.Typography.TitleL.extraBold)
            .foregroundStyle(Color.Palette.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }

    private var facultyChooserView: some View {
        Button {
            store.send(.facultyChanged(store.state.selectedFaculty))
        } label: {
            HStack(spacing: 12) {
                Text(store.state.selectedFaculty.isEmpty ? "Choose faculty" : store.state.selectedFaculty)
                    .font(Font.Typography.BodyTextSm.bold)
                    .foregroundStyle(
                        store.state.selectedFaculty.isEmpty
                        ? Color.Palette.grayPrimary
                        : Color.Palette.black
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(uiImage: UIImage.Icons.chevronDown02)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.Palette.grayQuaternary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
    }

    private var actionButtonsView: some View {
        HStack(spacing: 12) {
            Button {
                store.send(.skipTapped)
            } label: {
                Text("Skip")
                    .font(Font.Typography.BodyTextMd.medium)
                    .foregroundStyle(Color.Palette.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)

            AppButton(
                title: "Continue",
                model: .init(contentSize: .fill)
            ) {
                store.send(.continueTapped)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

#Preview("Browse Mode") {
    NavigationStack {
        FacultyStudentListView(store: browsePreviewViewModel.store)
    }
}

#Preview("Selection Mode") {
    NavigationStack {
        FacultyStudentListView(store: selectionPreviewViewModel.store)
    }
}

private var browsePreviewViewModel: PreviewFacultyStudentListViewModel {
    let state = FacultyStudentListViewState()
    state.title = "Students - 2002"
    state.facultyOptions = ["Computer engineering", "Chemistry"]
    state.selectedFaculty = "Choose faculty"
    state.searchText = ""
    state.isSelectionMode = false
    state.sections = previewBrowseSections
    return PreviewFacultyStudentListViewModel(state: state)
}

private var selectionPreviewViewModel: PreviewFacultyStudentListViewModel {
    let state = FacultyStudentListViewState()
    state.title = "Students - 2002"
    state.facultyOptions = ["Computer engineering", "Chemistry"]
    state.selectedFaculty = "Choose faculty"
    state.searchText = ""
    state.isSelectionMode = true
    state.sections = previewSelectableSections
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

private let previewSelectableSections: [MemberListSectionViewData] = [
    .init(
        id: "select-ce",
        title: "Computer engineering",
        memberCountText: "28 student",
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: true),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: true)
        ],
        showsSelectGroup: true,
        isGroupSelected: false
    ),
    .init(
        id: "select-chem",
        title: "Chemistry",
        memberCountText: "20 student",
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: false)
        ],
        showsSelectGroup: true,
        isGroupSelected: true
    )
]

private final class PreviewFacultyStudentListViewModel: UIFeatureViewModel<FacultyStudentListFeature> {
    init(state: FacultyStudentListViewState) {
        super.init(initialState: state)
    }

    override func handle(action: FacultyStudentListAction) {
    }
}
