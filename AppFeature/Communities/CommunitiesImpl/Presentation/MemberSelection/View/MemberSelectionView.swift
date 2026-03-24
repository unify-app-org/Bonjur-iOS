//
//  MemberSelectionView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct MemberSelectionView: View {
    @ObservedObject var store: StoreOf<MemberSelectionFeature>

    var body: some View {
        VStack(spacing: 16) {
            headerView

            facultyScrollView
        }
        .padding(.top, 16)
        .background(Color.Palette.grayQuaternary.opacity(0.3))
        .safeAreaInset(edge: .bottom) {
            actionBar
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 8)
                .background(Color.Palette.grayQuaternary.opacity(0.3))
                .background(Color.Palette.white)
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    private var facultyScrollView: some View {
        ScrollView(showsIndicators: false) {
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
            .padding(.horizontal, 16)
        }
    }
    private var headerView: some View {
        Text(store.state.title)
            .font(Font.Typography.TitleL.extraBold)
            .foregroundStyle(Color.Palette.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
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
                store.send(.nextTapped)
            }
          

            AppButton(
                title: "Next",
                model: .init(contentSize: .fill)
            ) {
                store.send(.nextTapped)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
#Preview("Default") {
    NavigationStack {
        MemberSelectionView(store: defaultPreviewViewModel.store)
    }
}

#Preview("Selected") {
    NavigationStack {
        MemberSelectionView(store: selectedPreviewViewModel.store)
    }
}

private var defaultPreviewViewModel: PreviewMemberSelectionViewModel {
    let state = MemberSelectionViewState()
    state.title = "Add members"
    state.rows = [
        .init(id: "1", title: "2002 - Bachelor", accessory: .selectable(isSelected: false)),
        .init(id: "2", title: "2002 - Master", accessory: .selectable(isSelected: false)),
        .init(id: "3", title: "2003 - Bachelor", accessory: .selectable(isSelected: false)),
        .init(id: "4", title: "2003 - Master", accessory: .selectable(isSelected: false))
    ]
    state.selectedSectionIDs = []
    return PreviewMemberSelectionViewModel(state: state)
}

private var selectedPreviewViewModel: PreviewMemberSelectionViewModel {
    let state = MemberSelectionViewState()
    state.title = "Add members"
    state.rows = [
        .init(id: "1", title: "2002 - Bachelor", accessory: .selectable(isSelected: false)),
        .init(id: "2", title: "2002 - Master", accessory: .selectable(isSelected: false)),
        .init(id: "3", title: "2003 - Bachelor", accessory: .selectable(isSelected: true)),
        .init(id: "4", title: "2003 - Master", accessory: .selectable(isSelected: false)),  .init(id: "5", title: "2002 - Bachelor", accessory: .selectable(isSelected: true)),
        .init(id: "6", title: "2002 - Master", accessory: .selectable(isSelected: false)),
        .init(id: "7", title: "2003 - Bachelor", accessory: .selectable(isSelected: true)),
        .init(id: "8", title: "2003 - Master", accessory: .selectable(isSelected: false)),  .init(id: "9", title: "2002 - Bachelor", accessory: .selectable(isSelected: true)),
        .init(id: "10", title: "2002 - Master", accessory: .selectable(isSelected: false)),
        .init(id: "11", title: "2003 - Bachelor", accessory: .selectable(isSelected: true)),
        .init(id: "12", title: "2003 - Master", accessory: .selectable(isSelected: false))
    ]
    state.selectedSectionIDs = ["1", "3"]
    return PreviewMemberSelectionViewModel(state: state)
}

private final class PreviewMemberSelectionViewModel: UIFeatureViewModel<MemberSelectionFeature> {
    init(state: MemberSelectionViewState) {
        super.init(initialState: state)
    }

    override func handle(action: MemberSelectionAction) {
    }
}
