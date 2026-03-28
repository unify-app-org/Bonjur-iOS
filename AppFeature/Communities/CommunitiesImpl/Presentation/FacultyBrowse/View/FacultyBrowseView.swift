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
        .init(id: "1", label: "2002 - Bachelor"),
        .init(id: "2", label: "2002 - Master"),
        .init(id: "3", label: "2002 - Doctoral"),
        .init(id: "4", label: "2003 - Bachelor"),
        .init(id: "5", label: "2003 - Master"),
        .init(id: "6", label: "2003 - Doctoral")
    ]

    return FacultyBrowseViewModel(
        state: state,
        router: PreviewFacultyBrowseRouter(),
        inputData: .init(
            title: state.title,
            sectionTitle: state.sectionTitle,
            faculties: state.faculties,
            onFacultyTapped: { _ in }
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
            onFacultyTapped: { _ in }
        ),
        dependencies: .init()
    )
}()

private final class PreviewFacultyBrowseRouter: FacultyBrowseRouterProtocol {
    @MainActor
    func navigate(to route: FacultyBrowseRoute) {
    }
}
