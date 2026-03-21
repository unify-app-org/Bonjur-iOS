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
                    
                    LazyVStack(spacing: 12) {
                        ForEach(store.state.faculties, id: \.id) { faculty in
                            facultyButton(faculty)
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
    @ViewBuilder
    func facultyButton(_ faculty: CommunitiesMemberModuleModel.FacultyRowModel)->some View{
        Button {
            store.send(.facultyTapped(faculty))
        } label: {
            HStack(spacing: 12) {
                Text(faculty.label)
                    .font(Font.Typography.BodyTextSm.bold)
                    .foregroundStyle(Color.Palette.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(uiImage: UIImage.Icons.chevronRight)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .padding(20)
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        MemberBrowseView(store: previewViewModel.store)
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

private final class PreviewMemberBrowseRouter: MemberBrowseRouterProtocol {
    @MainActor
    func navigate(to route: MemberBrowseRoute) {
    }
}
