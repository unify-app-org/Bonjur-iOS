//
//  ClubsView.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ClubsView: View {
    @ObservedObject var store: StoreOf<ClubsFeature>
    @State private var viewHeight: CGFloat = 0

    private var searchTextBinding: Binding<String> {
        Binding(
            get: { store.state.searchText },
            set: { store.send(.searchChanged($0)) }
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                Color.clear
                    .frame(height: viewHeight)
                scrollView
            }
            VStack(spacing: .zero) {
                topView
                Spacer()
            }
        }
        .navigationTitle("clubs_title".localized)
        .dismissKeyboardOnTap()
        .onAppear {
            store.send(.fetchData)
            store.send(.fetchCategories)
        }
    }
    
    @ViewBuilder
    private var scrollView: some View {
        let clubs = store.state.uiModel.clubs
        if clubs.isEmpty && store.state.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
        } else if !clubs.isEmpty {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(clubs.enumerated()), id: \.element.uuid) { index, item in
                        ClubCardView(model: item) {
                            store.send(.itemOnTap(id: item.id))
                        }
                        .onAppear {
                            loadMoreIfNeeded(index: index, count: clubs.count)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 55)
            }
        } else {
            emptyView
                .padding()
        }
    }

    /// Two empty states: nothing here at all (offer to create the first club),
    /// and nothing matching the active search/filters (nothing to create for).
    @ViewBuilder
    private var emptyView: some View {
        if isFiltering {
            AppEmptyView(
                model: .init(
                    icon: UIImage.Icons.twoUsers,
                    text: "clubs_search_empty".localized
                )
            )
        } else {
            AppEmptyView(
                model: .init(
                    icon: UIImage.Icons.twoUsers,
                    text: "clubs_list_empty".localized,
                    buttonTitle: "clubs_create_club".localized
                )
            ) {
                store.send(.createTapped)
            }
        }
    }

    private var isFiltering: Bool {
        !store.state.searchText.isEmpty
            || store.state.uiModel.filters.contains { $0.hasSelectedItems }
    }
    
    @ViewBuilder
    private var topView: some View {
        VStack(spacing: 24) {
//            Text("Clubs")
//                .font(Font.Typography.TitleL.extraBold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.horizontal)
            VStack(spacing: .zero) {
                SearchView(text: searchTextBinding)
                    .padding(.horizontal)
                FilterView(
                    model: store.state.uiModel.filters,
                    selectedItems: { items in
                        store.send(.filtersSelected(items))
                    }
                )
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { newValue in
            self.viewHeight = newValue
        }
        .background(Color.Palette.white)
    }

    private func loadMoreIfNeeded(index: Int, count: Int) {
        guard count > 0, index == count - 1 else { return }
        store.send(.loadMore)
    }
}


struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
