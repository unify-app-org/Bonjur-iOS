//
//  FacultySelectionView.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import SwiftUI
import AppFoundation
import AppUIKit

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

#Preview("Selected") {
    NavigationStack {
        FacultySelectionView(store: selectedPreviewViewModel.store)
    }
}

private var defaultPreviewViewModel: PreviewFacultySelectionViewModel {
    let state = FacultySelectionViewState()
    state.title = "Add members"
    state.sectionTitle = "Faculty"
    state.rows = [
        .init(id: "1", title: "2002 - Bachelor", accessory: .selectable(isSelected: false)),
        .init(id: "2", title: "2002 - Master", accessory: .selectable(isSelected: false)),
        .init(id: "3", title: "2003 - Bachelor", accessory: .selectable(isSelected: false)),
        .init(id: "4", title: "2003 - Master", accessory: .selectable(isSelected: false))
    ]
    state.selectedSectionIDs = []
    return PreviewFacultySelectionViewModel(state: state)
}

private var selectedPreviewViewModel: PreviewFacultySelectionViewModel {
    let state = FacultySelectionViewState()
    state.title = "Add members"
    state.sectionTitle = "Faculty"
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
    return PreviewFacultySelectionViewModel(state: state)
}

private final class PreviewFacultySelectionViewModel: UIFeatureViewModel<FacultySelectionFeature> {
    init(state: FacultySelectionViewState) {
        super.init(initialState: state)
    }

    override func handle(action: FacultySelectionAction) {
    }
}
