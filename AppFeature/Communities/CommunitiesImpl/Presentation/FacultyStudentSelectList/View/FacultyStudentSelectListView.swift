//
//  FacultyStudentSelectListView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//
import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct FacultyStudentSelectListView: View {
    @ObservedObject var store: StoreOf<FacultyStudentSelectListFeature>

    var body: some View {
        ScrollView{
            VStack(spacing: 16) {
                
                
                SearchView(text: searchTextBinding)
                    .padding([.horizontal,.top], 16)
                
                selectAllView
                    .padding(.horizontal, 16)
                
                if store.state.filteredSections.isEmpty, !store.state.searchText.isEmpty {
                    emptySearchStateView
                } else {
                    MemberListView(
                        sections: store.state.filteredSections,
                        onRowTap: { store.send(.memberTapped($0)) },
                        onAccessoryTap: { _ in },
                        onSelectGroupTap: { store.send(.groupTapped($0)) }
                    )
                }
                
                
             
            }
        }
        .safeAreaInset(edge: .bottom) {
            continueButton
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
            set: { store.send(.searchChanged($0)) }
        )
    }

   
    private var selectAllView: some View {
        Button {
            store.send(.selectAllTapped)
        } label: {
            HStack(spacing: 12) {
                Image(uiImage: store.state.isAllSelected ? .Icons.selectedCheckBox : .Icons.notSelectedCheckBox)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text("select all member")
                    .font(Font.Typography.BodyTextSm.medium)
                    .foregroundStyle(Color.Palette.grayPrimary)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.Palette.grayQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
    }

    private var emptySearchStateView: some View {
        Text("No students found")
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }

    private var continueButton: some View {
        AppButton(
            title: "Continue",
            model: .init(contentSize: .fill)
        ) {
            store.send(.continueTapped)
        }
       
        .padding(.horizontal, 16)
        .padding(.top, 8)
      
        .background(Color.Palette.grayQuaternary.opacity(0.3))
        .background(Color.Palette.white)
    }
}











#Preview("Default") {
    NavigationStack {
        FacultyStudentSelectListView(store: defaultPreviewViewModel.store)
    }
}

#Preview("All Selected") {
    NavigationStack {
        FacultyStudentSelectListView(store: allSelectedPreviewViewModel.store)
    }
}

private var defaultPreviewViewModel: PreviewFacultyStudentSelectListViewModel {
    let state = FacultyStudentSelectListViewState()
    state.title = "Students - 2002"
    state.searchText = ""
    state.sections = previewSelectableSections
    state.filteredSections = previewSelectableSections
    state.selectedIDs = []
    state.isAllSelected = false
    return PreviewFacultyStudentSelectListViewModel(state: state)
}

private var allSelectedPreviewViewModel: PreviewFacultyStudentSelectListViewModel {
    let state = FacultyStudentSelectListViewState()
    state.title = "Students - 2002"
    state.searchText = ""
    state.sections = previewAllSelectedSections
    state.filteredSections = previewAllSelectedSections
    state.selectedIDs = Set(
        previewAllSelectedSections
            .flatMap(\.rows)
            .map(\.id)
    )
    state.isAllSelected = true
    return PreviewFacultyStudentSelectListViewModel(state: state)
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

private let previewSelectableSections: [MemberListSectionViewData] = [
    .init(
        id: "select-ce",
        title: "Computer engineering",
        memberCountText: nil,
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: false),
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: false)
        ],
        showsSelectGroup: true,
        isGroupSelected: false
    ),
    .init(
        id: "select-chem",
        title: "Chemistry",
        memberCountText: nil,
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: false),
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[0], isSelected: false),
            .selectable(from: studentPreviewMembers[1], isSelected: false),
            .selectable(from: studentPreviewMembers[2], isSelected: false)
        ],
        showsSelectGroup: true,
        isGroupSelected: false
    )
]

private let previewAllSelectedSections: [MemberListSectionViewData] = [
    .init(
        id: "all-ce",
        title: "Computer engineering",
        memberCountText: nil,
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: true),
            .selectable(from: studentPreviewMembers[1], isSelected: true),
            .selectable(from: studentPreviewMembers[2], isSelected: true),
            .selectable(from: studentPreviewMembers[0], isSelected: true)
        ],
        showsSelectGroup: true,
        isGroupSelected: true
    ),
    .init(
        id: "all-chem",
        title: "Chemistry",
        memberCountText: nil,
        rows: [
            .selectable(from: studentPreviewMembers[0], isSelected: true),
            .selectable(from: studentPreviewMembers[1], isSelected: true),
            .selectable(from: studentPreviewMembers[2], isSelected: true)
        ],
        showsSelectGroup: true,
        isGroupSelected: true
    )
]

private final class PreviewFacultyStudentSelectListViewModel: UIFeatureViewModel<FacultyStudentSelectListFeature> {
    init(state: FacultyStudentSelectListViewState) {
        super.init(initialState: state)
    }

    override func handle(action: FacultyStudentSelectListAction) {
    }
}
