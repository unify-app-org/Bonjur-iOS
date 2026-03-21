//
//  MemberBrowseView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct MemberBrowseView: View {
    @ObservedObject var store: StoreOf<MemberBrowseFeature>

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                headerView
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
               
            }
            .padding(16)
        }
        .background(Color.Palette.grayQuaternary.opacity(0.2))
      
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
    var headerView:some View{
        Text(store.state.title)
            .font(Font.Typography.TitleL.extraBold)
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

#Preview {
    NavigationStack {
        MemberBrowseView(store: previewViewModel.store)
    }
}

#Preview("Empty State") {
    NavigationStack {
        MemberBrowseView(store: emptyPreviewViewModel.store)
    }
}

private var previewViewModel: MemberBrowseViewModel {
    let state = MemberBrowseViewState()
    state.title = "All member"
    state.sectionTitle = "Faculty"
    state.faculties = [
        .init(id: "1", label: "2002 - Bachelor"),
        .init(id: "2", label: "2002 - Master"),
        .init(id: "3", label: "2002 - Doctoral"),
        .init(id: "4", label: "2003 - Bachelor"),
        .init(id: "5", label: "2003 - Master"),
        .init(id: "6", label: "2003 - Doctoral")
    ]

    return MemberBrowseViewModel(
        state: state,
        router: PreviewMemberBrowseRouter(),
        inputData: .init(
            title: state.title,
            sectionTitle: state.sectionTitle,
            faculties: state.faculties,
            onFacultyTapped: { _ in }
        ),
        dependencies: .init()
    )
}

private var emptyPreviewViewModel: MemberBrowseViewModel {
    let state = MemberBrowseViewState()
    state.title = "All member"
    state.sectionTitle = "Faculty"
    state.faculties = []

    return MemberBrowseViewModel(
        state: state,
        router: PreviewMemberBrowseRouter(),
        inputData: .init(
            title: state.title,
            sectionTitle: state.sectionTitle,
            faculties: state.faculties,
            onFacultyTapped: { _ in }
        ),
        dependencies: .init()
    )
}

private final class PreviewMemberBrowseRouter: MemberBrowseRouterProtocol {
    @MainActor
    func navigate(to route: MemberBrowseRoute) {
    }
}
