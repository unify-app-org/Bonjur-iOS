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

private let defaultPreviewViewModel: PreviewFacultySelectionViewModel = {
    PreviewFacultySelectionViewModel(
        title: "Add members",
        sectionTitle: "Faculty",
        rows: previewFacultyRows,
        selectedIDs: []
    )
}()

private let selectedPreviewViewModel: PreviewFacultySelectionViewModel = {
    PreviewFacultySelectionViewModel(
        title: "Add members",
        sectionTitle: "Faculty",
        rows: previewFacultyRows,
        selectedIDs: ["1", "3", "5"]
    )
}()

private struct PreviewFacultySelectionRow: Identifiable {
    let id: String
    let title: String
}

private let previewFacultyRows: [PreviewFacultySelectionRow] = [
    .init(id: "1", title: "2002 - Bachelor"),
    .init(id: "2", title: "2002 - Master"),
    .init(id: "3", title: "2002 - Doctoral"),
    .init(id: "4", title: "2003 - Bachelor"),
    .init(id: "5", title: "2003 - Master"),
    .init(id: "6", title: "2003 - Doctoral")
]

private final class PreviewFacultySelectionViewModel: UIFeatureViewModel<FacultySelectionFeature> {
    private let sourceRows: [PreviewFacultySelectionRow]

    init(
        title: String,
        sectionTitle: String,
        rows: [PreviewFacultySelectionRow],
        selectedIDs: Set<String>
    ) {
        self.sourceRows = rows

        let state = FacultySelectionViewState()
        state.title = title
        state.sectionTitle = sectionTitle
        state.selectedSectionIDs = selectedIDs

        super.init(initialState: state)
        rebuildRows()
    }

    override func handle(action: FacultySelectionAction) {
        switch action {
        case .rowTapped(let row):
            if state.selectedSectionIDs.contains(row.id) {
                state.selectedSectionIDs.remove(row.id)
            } else {
                state.selectedSectionIDs.insert(row.id)
            }
            rebuildRows()

        case .onAppear, .nextTapped, .skipTapped:
            break
        }
    }

    private func rebuildRows() {
        state.rows = sourceRows.map { row in
            FacultyRowViewData(
                id: row.id,
                title: row.title,
                accessory: .selectable(
                    isSelected: state.selectedSectionIDs.contains(row.id)
                )
            )
        }
    }
}
