//
//  FacultySelectionView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct FacultySelectionView: View {
    @ObservedObject var store: StoreOf<FacultySelectionFeature>

    var body: some View {
        
            ScrollView(showsIndicators: false) {
             
                    VStack(alignment: .leading, spacing: 16) {
                        facultyTextView
                        if store.state.rows.isEmpty {
                            emptyStateView
                        } else {
                            facultyScrollView
                        }
                    }
                
                .padding(16)
            }
        .background(Color.Palette.grayQuaternary.opacity(0.3))
        .navigationTitle(store.state.title)
        .safeAreaInset(edge: .bottom) {
            actionBar
             
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    private var facultyScrollView: some View {
    
            LazyVStack(spacing: 12) {
                ForEach(store.state.rows) { row in
                    FacultyRowView(
                        data: row,
                        onTap: {
                            store.send(.rowTapped(row))
                        }
                    )
                }
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
    private var actionBar: some View {
        HStack(spacing: 12) {
            AppButton(
                title: "Skip",
                model:.init(
                    type: .tertiary,
                    contentSize: .fit,
                    size: .large
                )
                
            ) {
                store.send(.skipTapped)
            }
          

            AppButton(
                title: "Next",
                model: .init(contentSize: .fill)
            ) {
                store.send(.nextTapped)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .background(Color.Palette.grayQuaternary.opacity(0.3))
        .background(Color.Palette.white)
    }
}
#Preview("Default") {
    NavigationStack {
        FacultySelectionView(store: defaultPreviewViewModel.store)
    }
}


private let defaultPreviewViewModel: FacultySelectionViewModel = {
    FacultySelectionViewModel(
        state: .init(),
        router: PreviewFacultySelectionRouter(),
        inputData: .init(
            title: "Add members",
            sectionTitle: "Faculty",
            sections: previewFacultySections,
            capacityLimit: nil,
            onNext: { _ in },
            onSkip: {}
        ),
        dependencies: .init()
    )
}()



private let previewFacultySections: [CommunitiesMemberModuleModel.MemberListSection] = [
    .init(
        title: "2002 - Bachelor",
        members: [
            .init(
                id: "member-1",
                name: "Nihad Asgarli",
                avatarURL: URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg"),
                subtitle: "Bachelor, Computer engineering, 2017"
            )
        ]
    ),
    .init(
        title: "2002 - Master",
        members: [
            .init(
                id: "member-2",
                name: "Huseyn Hasanov",
                avatarURL: URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg"),
                subtitle: "Master, Computer engineering, 2017"
            )
        ]
    ),
    .init(
        title: "2002 - Doctoral",
        members: [
            .init(
                id: "member-3",
                name: "Durdana Hasanova",
                avatarURL: URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg"),
                subtitle: "Doctoral, Computer engineering, 2017"
            )
        ]
    ),
    .init(
        title: "2003 - Bachelor",
        members: [
            .init(
                id: "member-4",
                name: "Nihad Asgarli",
                avatarURL: URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg"),
                subtitle: "Bachelor, Chemistry, 2017"
            )
        ]
    ),
    .init(
        title: "2003 - Master",
        members: [
            .init(
                id: "member-5",
                name: "Huseyn Hasanov",
                avatarURL: URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg"),
                subtitle: "Master, Chemistry, 2017"
            )
        ]
    ),
    .init(
        title: "2003 - Doctoral",
        members: [
            .init(
                id: "member-6",
                name: "Durdana Hasanova",
                avatarURL: URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg"),
                subtitle: "Doctoral, Chemistry, 2017"
            )
        ]
    )
]

private final class PreviewFacultySelectionRouter: FacultySelectionRouterProtocol {
    @MainActor
    func navigate(to route: FacultySelectionRoute) {
    }
}
